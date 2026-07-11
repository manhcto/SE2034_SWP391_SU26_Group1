document.addEventListener('DOMContentLoaded', function () {
    setupDestinationFilter();
    setupTransportDriverRule();
    setupDateRules();
    setupDraftPrice();
    setupScheduleDraftAdd();
    setupItineraryRenderer();
    setupImagePreview();
    setupCreateFormClientValidation();
});

function setupDestinationFilter() {
    const region = document.getElementById('regionID');
    const selects = document.querySelectorAll('.destination-select');
    if (!region || selects.length === 0) return;

    function filter() {
        const regionValue = region.value || '';
        selects.forEach(function (select) {
            Array.from(select.options).forEach(function (option) {
                if (!option.value) {
                    option.hidden = false;
                    return;
                }
                const optionRegion = option.getAttribute('data-region') || '';
                const allow = !regionValue || optionRegion === regionValue;
                option.hidden = !allow;
                option.disabled = !allow;
            });
            const selected = select.options[select.selectedIndex];
            if (selected && selected.disabled) {
                select.value = '';
            }
        });
    }

    region.addEventListener('change', filter);
    filter();
}

function setupTransportDriverRule() {
    const transport = document.getElementById('mainTransportType') || document.querySelector('[name="mainTransportType"]');
    const driver = document.getElementById('draftDriverStaffID');
    if (!transport || !driver) return;

    function update() {
        if (transport.value === 'Đường sắt') {
            driver.value = '';
            driver.disabled = true;
            driver.classList.add('is-disabled');
        } else {
            driver.disabled = false;
            driver.classList.remove('is-disabled');
        }
    }
    transport.addEventListener('change', update);
    update();
}

function setupDateRules() {
    const departure = document.getElementById('draftDepartureDate');
    const returning = document.getElementById('draftReturnDate');
    const close = document.getElementById('draftBookingCloseDate');
    const daysInput = document.querySelector('[name="numberOfDays"]');
    if (!departure || !returning || !close) return;

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = addDays(today, 1);
    const todayText = toDateInput(today);
    const tomorrowText = toDateInput(tomorrow);

    // Vì ngày chốt bán phải trước ngày khởi hành và không được ở quá khứ,
    // ngày khởi hành sớm nhất hợp lệ là ngày mai.
    departure.min = tomorrowText;
    close.min = todayText;
    returning.min = tomorrowText;

    function syncDates() {
        if (!departure.value) return;
        const dep = fromDateInput(departure.value);
        if (!dep) return;

        if (dep < tomorrow) {
            departure.value = tomorrowText;
        }

        const finalDeparture = fromDateInput(departure.value);
        const numberOfDays = Math.max(parseInt(daysInput?.value || '1', 10) || 1, 1);
        const ret = addDays(finalDeparture, numberOfDays - 1);
        returning.value = toDateInput(ret);
        returning.min = departure.value;

        const latestClose = addDays(finalDeparture, -1);
        close.max = toDateInput(latestClose);

        if (!close.value || close.value < todayText || close.value >= departure.value) {
            close.value = toDateInput(latestClose < today ? today : latestClose);
        }
    }

    // Tạo giá trị mặc định để người dùng không vô tình thêm lịch ở quá khứ.
    if (!departure.value) {
        departure.value = tomorrowText;
    }
    syncDates();

    departure.addEventListener('change', syncDates);
    daysInput?.addEventListener('change', syncDates);
}

function setupDraftPrice() {
    ['draftAdultPrice', 'draftChildPrice', 'draftInfantPrice', 'draftSingleRoomSurcharge', 'draftDepositPercent', 'draftVatPercent', 'draftHasVAT']
        .forEach(function (id) {
            const el = document.getElementById(id);
            if (el) {
                el.addEventListener('input', updateDraftPrice);
                el.addEventListener('change', updateDraftPrice);
            }
        });
    updateDraftPrice();
}

function updateDraftPrice() {
    const summary = document.getElementById('draftPriceSummary');
    if (!summary) return;
    const adult = parseMoney(valueOf('draftAdultPrice'));
    const child = parseMoney(valueOf('draftChildPrice'));
    const infant = parseMoney(valueOf('draftInfantPrice'));
    const single = parseMoney(valueOf('draftSingleRoomSurcharge'));
    const deposit = parseMoney(valueOf('draftDepositPercent'));
    const hasVAT = document.getElementById('draftHasVAT')?.checked;
    const vat = parseMoney(valueOf('draftVatPercent'));
    if (!adult) {
        summary.textContent = 'Giá: chưa tính';
        summary.setAttribute('data-tooltip', '');
        return;
    }
    const display = hasVAT ? adult + Math.floor(adult * vat / 100) : adult;
    summary.textContent = 'Giá: ' + formatMoney(display) + ' VND';
    summary.setAttribute('data-tooltip', buildPriceTooltip(adult, child, infant, single, deposit, hasVAT, vat));
}

function setupScheduleDraftAdd() {
    const addBtn = document.getElementById('addScheduleDraftBtn');
    const countInput = document.getElementById('scheduleCount');
    const hiddenContainer = document.getElementById('scheduleHiddenContainer');
    const previewBody = document.getElementById('schedulePreviewBody');
    if (!addBtn || !countInput || !hiddenContainer || !previewBody) return;

    addBtn.addEventListener('click', function () {
        const transport = (document.getElementById('mainTransportType') || document.querySelector('[name="mainTransportType"]'))?.value || '';
        const draft = {
            departureDate: valueOf('draftDepartureDate'),
            returnDate: valueOf('draftReturnDate'),
            bookingCloseDate: valueOf('draftBookingCloseDate'),
            minParticipants: valueOf('draftMinParticipants'),
            maxParticipants: valueOf('draftMaxParticipants'),
            guideStaffID: valueOf('draftGuideStaffID'),
            guideText: textOfSelected('draftGuideStaffID'),
            driverStaffID: transport === 'Đường sắt' ? '' : valueOf('draftDriverStaffID'),
            driverText: transport === 'Đường sắt' ? 'Không cần' : textOfSelected('draftDriverStaffID'),
            adultPrice: parseMoney(valueOf('draftAdultPrice')),
            childPrice: parseMoney(valueOf('draftChildPrice')),
            infantPrice: parseMoney(valueOf('draftInfantPrice')),
            singleRoomSurcharge: parseMoney(valueOf('draftSingleRoomSurcharge')),
            depositPercent: parseMoney(valueOf('draftDepositPercent')),
            hasVAT: document.getElementById('draftHasVAT')?.checked,
            vatPercent: parseMoney(valueOf('draftVatPercent'))
        };

        const error = validateDraftSchedule(draft, transport);
        if (error) {
            alert(error);
            return;
        }

        const next = getNextScheduleIndex();
        countInput.value = String(Math.max(next, parseInt(countInput.value || '0', 10) + 1));
        addHiddenSchedule(hiddenContainer, next, draft);
        addPreviewRow(previewBody, next, draft, true);
        clearEmptyRow();
        clearDraftSchedule();
    });
}

function validateDraftSchedule(draft, transport) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const todayText = toDateInput(today);
    const tomorrowText = toDateInput(addDays(today, 1));
    if (!draft.departureDate || !draft.returnDate || !draft.bookingCloseDate || !draft.guideStaffID) {
        return 'Vui lòng nhập ngày khởi hành, ngày về, hạn chót bán và hướng dẫn viên.';
    }
    if (draft.departureDate < tomorrowText) return 'Ngày khởi hành phải từ ngày mai trở đi vì ngày chốt bán phải trước ngày khởi hành.';
    if (draft.bookingCloseDate < todayText) return 'Hạn chót bán không được ở quá khứ.';
    if (draft.bookingCloseDate >= draft.departureDate) return 'Hạn chót bán phải trước ngày khởi hành.';
    if (draft.returnDate < draft.departureDate) return 'Ngày về không được trước ngày khởi hành.';

    const numberOfDays = parseInt(document.querySelector('[name="numberOfDays"]')?.value || '1', 10) || 1;
    const diff = dayDiff(fromDateInput(draft.departureDate), fromDateInput(draft.returnDate)) + 1;
    if (diff !== numberOfDays) return 'Ngày về phải khớp số ngày của tour. Ví dụ tour ' + numberOfDays + ' ngày thì ngày về = ngày khởi hành + ' + (numberOfDays - 1) + ' ngày.';

    if (transport !== 'Đường sắt' && !draft.driverStaffID) return 'Vui lòng chọn nhân viên lái xe cho phương tiện đường bộ.';
    if (!draft.adultPrice) return 'Vui lòng nhập giá người lớn cho lịch khởi hành.';
    if (draft.childPrice > draft.adultPrice) return 'Giá trẻ em không được vượt giá người lớn.';
    if (draft.infantPrice > draft.childPrice) return 'Giá em bé không được vượt giá trẻ em. Nếu chưa nhập giá trẻ em thì để giá em bé bằng 0.';
    if (parseInt(draft.minParticipants || '0', 10) <= 0) return 'Số khách tối thiểu phải lớn hơn 0.';
    if (parseInt(draft.maxParticipants || '0', 10) < parseInt(draft.minParticipants || '0', 10)) return 'Số khách tối đa phải lớn hơn hoặc bằng số khách tối thiểu.';
    return '';
}

function getNextScheduleIndex() {
    let max = 0;
    document.querySelectorAll('.schedule-hidden-set[data-index]').forEach(function (node) {
        max = Math.max(max, parseInt(node.getAttribute('data-index') || '0', 10));
    });
    return max + 1;
}

function addHiddenSchedule(container, index, draft) {
    const wrap = document.createElement('div');
    wrap.className = 'schedule-hidden-set';
    wrap.setAttribute('data-index', index);
    const fields = {
        ['departureDate_' + index]: draft.departureDate,
        ['returnDate_' + index]: draft.returnDate,
        ['bookingCloseDate_' + index]: draft.bookingCloseDate,
        ['minParticipants_' + index]: draft.minParticipants,
        ['maxParticipants_' + index]: draft.maxParticipants,
        ['guideStaffID_' + index]: draft.guideStaffID,
        ['driverStaffID_' + index]: draft.driverStaffID,
        ['adultPrice_' + index]: draft.adultPrice,
        ['childPrice_' + index]: draft.childPrice,
        ['infantPrice_' + index]: draft.infantPrice,
        ['singleRoomSurcharge_' + index]: draft.singleRoomSurcharge,
        ['depositPercent_' + index]: draft.depositPercent,
        ['vatPercent_' + index]: draft.hasVAT ? draft.vatPercent : 0
    };
    Object.keys(fields).forEach(function (name) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = name;
        input.value = fields[name] ?? '';
        wrap.appendChild(input);
    });
    if (draft.hasVAT) {
        const vat = document.createElement('input');
        vat.type = 'hidden';
        vat.name = 'hasVAT_' + index;
        vat.value = 'on';
        wrap.appendChild(vat);
    }
    container.appendChild(wrap);
}

function addPreviewRow(body, index, draft, removable) {
    const display = draft.hasVAT ? draft.adultPrice + Math.floor(draft.adultPrice * draft.vatPercent / 100) : draft.adultPrice;
    const row = document.createElement('tr');
    row.setAttribute('data-index', index);
    row.innerHTML = `
        <td>${index}</td>
        <td>${escapeHtml(draft.departureDate)}</td>
        <td>${escapeHtml(draft.returnDate)}</td>
        <td>${escapeHtml(draft.bookingCloseDate)}</td>
        <td>${escapeHtml(draft.minParticipants)}</td>
        <td>0/${escapeHtml(draft.maxParticipants)}</td>
        <td>${escapeHtml(draft.guideText)}</td>
        <td>${escapeHtml(draft.driverText)}</td>
        <td><span class="price-summary" data-tooltip="${escapeHtml(buildPriceTooltip(draft.adultPrice, draft.childPrice, draft.infantPrice, draft.singleRoomSurcharge, draft.depositPercent, draft.hasVAT, draft.vatPercent))}">${formatMoney(display)} VND</span></td>
        <td>${removable ? '<button type="button" class="table-action" onclick="removeScheduleRow(' + index + ')">Xóa</button>' : ''}</td>
    `;
    body.appendChild(row);
}

function removeScheduleRow(index) {
    document.querySelector('.schedule-hidden-set[data-index="' + index + '"]')?.remove();
    document.querySelector('#schedulePreviewBody tr[data-index="' + index + '"]')?.remove();
    const countInput = document.getElementById('scheduleCount');
    if (countInput) countInput.value = String(document.querySelectorAll('.schedule-hidden-set[data-index]').length);
    const body = document.getElementById('schedulePreviewBody');
    if (body && document.querySelectorAll('.schedule-hidden-set[data-index]').length === 0 && !document.getElementById('emptyScheduleRow')) {
        const empty = document.createElement('tr');
        empty.id = 'emptyScheduleRow';
        empty.innerHTML = '<td colspan="10">Chưa có lịch khởi hành nào.</td>';
        body.appendChild(empty);
    }
}

function clearEmptyRow() { document.getElementById('emptyScheduleRow')?.remove(); }
function clearDraftSchedule() {
    ['draftDepartureDate','draftReturnDate','draftBookingCloseDate','draftAdultPrice','draftChildPrice','draftInfantPrice','draftSingleRoomSurcharge'].forEach(function (id) { const el = document.getElementById(id); if (el) el.value = ''; });
    const guide = document.getElementById('draftGuideStaffID'); if (guide) guide.selectedIndex = 0;
    const driver = document.getElementById('draftDriverStaffID'); if (driver && !driver.disabled) driver.selectedIndex = 0;
    updateDraftPrice();
}

function setupItineraryRenderer() {
    const input = document.querySelector('[name="numberOfDays"]');
    const container = document.getElementById('itineraryContainer');
    if (!input || !container) return;
    input.addEventListener('change', function () { renderItineraryDays(parseInt(input.value || '1', 10)); });
    renderItineraryDays(parseInt(input.value || '1', 10));
}

function collectCurrentItineraries() {
    const items = [];
    document.querySelectorAll('#itineraryContainer .day-card').forEach(function (card, idx) {
        const day = idx + 1;
        items.push({
            transportDescription: card.querySelector('[name="transportDescription_' + day + '"]')?.value || '',
            experienceActivities: card.querySelector('[name="experienceActivities_' + day + '"]')?.value || '',
            accommodationDescription: card.querySelector('[name="accommodationDescription_' + day + '"]')?.value || '',
            note: card.querySelector('[name="note_' + day + '"]')?.value || ''
        });
    });
    return items;
}

function renderItineraryDays(count) {
    const container = document.getElementById('itineraryContainer');
    if (!container) return;
    if (count < 1) count = 1;
    if (count > 30) count = 30;
    const old = collectCurrentItineraries();
    container.innerHTML = '';
    for (let i = 1; i <= count; i++) {
        const data = old[i - 1] || {};
        const card = document.createElement('div');
        card.className = 'day-card';
        card.innerHTML = `
            <div class="day-card-header"><div class="day-title">Ngày ${i}</div></div>
            <div class="form-group"><label>Di chuyển từ đâu đến đâu <span class="required">*</span></label><input class="form-control" name="transportDescription_${i}" value="${escapeHtml(data.transportDescription || '')}" placeholder="Ví dụ: Hà Nội → Hạ Long"></div>
            <div class="form-group"><label>Hoạt động trải nghiệm <span class="required">*</span></label><textarea name="experienceActivities_${i}" placeholder="Mỗi hoạt động một dòng">${escapeHtml(data.experienceActivities || '')}</textarea></div>
            <div class="form-group"><label>Lưu trú</label><input class="form-control" name="accommodationDescription_${i}" value="${escapeHtml(data.accommodationDescription || '')}" placeholder="Ví dụ: Khách sạn 4 sao"></div>
            <div class="form-group"><label>Lưu ý</label><textarea name="note_${i}" placeholder="Nhập lưu ý nếu có">${escapeHtml(data.note || '')}</textarea></div>
        `;
        container.appendChild(card);
    }
}

function setupImagePreview() {
    document.querySelectorAll('.image-input').forEach(function (input) {
        input.addEventListener('change', function () {
            const target = input.getAttribute('data-preview');
            if (!input.files || !target) return;
            if (input.name === 'coverImage') {
                const img = document.getElementById(target);
                if (img && input.files[0]) {
                    img.src = URL.createObjectURL(input.files[0]);
                    img.style.display = 'block';
                }
            } else {
                const box = document.getElementById(target);
                if (!box) return;
                box.innerHTML = '';
                Array.from(input.files).forEach(function (file) {
                    const img = document.createElement('img');
                    img.src = URL.createObjectURL(file);
                    box.appendChild(img);
                });
            }
        });
    });
}

function setupCreateFormClientValidation() {
    const form = document.getElementById('tourCreateForm');
    if (!form) return;
    form.addEventListener('submit', function (event) {
        const scheduleCount = document.querySelectorAll('.schedule-hidden-set[data-index]').length;
        if (scheduleCount === 0) {
            event.preventDefault();
            alert('Bạn cần thêm ít nhất một lịch khởi hành vào danh sách trước khi tạo tour.');
            return;
        }
        const days = parseInt(document.querySelector('[name="numberOfDays"]')?.value || '1', 10) || 1;
        for (let i = 1; i <= days; i++) {
            if (!document.querySelector('[name="transportDescription_' + i + '"]')?.value.trim()) {
                event.preventDefault();
                alert('Vui lòng nhập mô tả di chuyển cho Ngày ' + i + '.');
                return;
            }
            if (!document.querySelector('[name="experienceActivities_' + i + '"]')?.value.trim()) {
                event.preventDefault();
                alert('Vui lòng nhập hoạt động trải nghiệm cho Ngày ' + i + '.');
                return;
            }
        }
    });
}

function buildPriceTooltip(adult, child, infant, single, deposit, hasVAT, vat) {
    return 'Người lớn: ' + formatMoney(adult) + ' VND\n'
        + 'Trẻ em: ' + formatMoney(child) + ' VND\n'
        + 'Em bé: ' + formatMoney(infant) + ' VND\n'
        + 'Phụ thu phòng đơn: ' + formatMoney(single) + ' VND\n'
        + 'Đặt cọc: ' + deposit + '%\n'
        + 'VAT: ' + (hasVAT ? vat + '%' : 'Không áp dụng');
}

function valueOf(id) { const el = document.getElementById(id); return el ? el.value : ''; }
function textOfSelected(id) { const el = document.getElementById(id); if (!el || el.selectedIndex < 0) return ''; return el.options[el.selectedIndex].text || ''; }
function parseMoney(value) { if (!value) return 0; return parseInt(String(value).replace(/[^\d]/g, ''), 10) || 0; }
function formatMoney(value) { return new Intl.NumberFormat('vi-VN').format(value || 0); }
function escapeHtml(value) { return String(value ?? '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;'); }
function fromDateInput(value) { if (!value) return null; const parts = value.split('-').map(Number); return new Date(parts[0], parts[1] - 1, parts[2]); }
function toDateInput(date) { const d = new Date(date); d.setMinutes(d.getMinutes() - d.getTimezoneOffset()); return d.toISOString().slice(0, 10); }
function addDays(date, days) { const d = new Date(date); d.setDate(d.getDate() + days); return d; }
function dayDiff(a, b) { return Math.round((b - a) / 86400000); }
