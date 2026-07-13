document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('[data-confirm]').forEach(function (element) {
        element.addEventListener('click', function (event) {
            if (!confirm(element.getAttribute('data-confirm'))) {
                event.preventDefault();
            }
        });
    });

    function escapeHtml(value) {
        return String(value || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    function field(card, suffix) {
        return card.querySelector('[name$="_' + suffix + '"]');
    }

    var dayInput = document.getElementById('numberOfDays');
    var nightInput = document.getElementById('numberOfNights');
    var itineraryList = document.getElementById('itineraryList');
    var addItineraryBtn = document.getElementById('addItineraryBtn');
    var itineraryTemplate = document.getElementById('itineraryTemplate');

    function syncNight() {
        if (!dayInput || !nightInput) return;
        var days = parseInt(dayInput.value || '1', 10);
        if (isNaN(days) || days < 1) days = 1;
        nightInput.value = Math.max(days - 1, 0);
        refreshDaySelects();
    }

    function refreshDaySelects() {
        if (!dayInput || !itineraryList) return;
        var days = parseInt(dayInput.value || '1', 10);
        if (isNaN(days) || days < 1) days = 1;
        itineraryList.querySelectorAll('[data-day-select]').forEach(function (select, idx) {
            var selected = select.value || select.getAttribute('data-selected-day') || String(Math.min(idx + 1, days));
            select.innerHTML = '';
            for (var day = 1; day <= days; day++) {
                var option = document.createElement('option');
                option.value = String(day);
                option.textContent = 'Ngày ' + day;
                if (String(day) === String(selected)) option.selected = true;
                select.appendChild(option);
            }
            select.setAttribute('data-selected-day', select.value);
            updateItineraryTitle(select.closest('.itinerary-card'));
        });
    }

    function updateItineraryTitle(card) {
        if (!card) return;
        var select = card.querySelector('[data-day-select]');
        var label = card.querySelector('.itinerary-card-title span');
        if (select && label) label.textContent = 'Ngày ' + select.value;
    }

    if (dayInput && nightInput) {
        dayInput.addEventListener('input', syncNight);
        syncNight();
    }

    if (addItineraryBtn && itineraryList && itineraryTemplate) {
        addItineraryBtn.addEventListener('click', function () {
            var wrapper = document.createElement('div');
            wrapper.innerHTML = itineraryTemplate.innerHTML.trim();
            itineraryList.appendChild(wrapper.firstElementChild);
            refreshDaySelects();
        });

        itineraryList.addEventListener('click', function (event) {
            var removeBtn = event.target.closest('[data-remove-itinerary]');
            if (!removeBtn) return;
            var rows = itineraryList.querySelectorAll('.itinerary-card');
            if (rows.length > 1) {
                removeBtn.closest('.itinerary-card').remove();
            } else {
                removeBtn.closest('.itinerary-card').querySelectorAll('input, textarea').forEach(function (input) { input.value = ''; });
            }
        });

        itineraryList.addEventListener('change', function (event) {
            if (event.target.matches('[data-day-select]')) {
                event.target.setAttribute('data-selected-day', event.target.value);
                updateItineraryTitle(event.target.closest('.itinerary-card'));
            }
        });
    }

    var transportSelect = document.getElementById('transportTypeSelect');
    var seatSelect = document.getElementById('transportSeatSelect');
    var seatByType = {
        'Ô tô': [4, 7, 9, 16, 29, 35, 45],
        'Xe khách': [16, 29, 35, 45, 47, 49],
        'Xe giường nằm': [22, 34, 40, 44],
        'Đường sắt': [64, 80, 100, 120]
    };

    function fillSeatOptions() {
        if (!transportSelect || !seatSelect) return;
        var type = transportSelect.value;
        var seats = seatByType[type] || [];
        var current = seatSelect.value;
        seatSelect.innerHTML = '<option value="">-- Chọn số chỗ --</option>';
        seats.forEach(function (seat) {
            var option = document.createElement('option');
            option.value = String(seat);
            option.textContent = seat + ' chỗ';
            if (String(seat) === String(current)) option.selected = true;
            seatSelect.appendChild(option);
        });
        if (!seatSelect.value && seats.length > 0) seatSelect.value = String(seats[0]);
        syncSeatToSchedules(false);
    }

    function syncSeatToSchedules(force) {
        if (!seatSelect || !seatSelect.value) return;
        document.querySelectorAll('[data-max-participants]').forEach(function (input) {
            if (force || !input.value) input.value = seatSelect.value;
        });
        updateScheduleSummary();
    }

    if (transportSelect && seatSelect) {
        transportSelect.addEventListener('change', fillSeatOptions);
        seatSelect.addEventListener('change', function () { syncSeatToSchedules(true); });
        fillSeatOptions();
    }

    var coverInput = document.getElementById('coverImageInput');
    var coverPreview = document.getElementById('coverPreview');
    var coverPreviewEmpty = document.getElementById('coverPreviewEmpty');
    if (coverInput && coverPreview) {
        coverInput.addEventListener('change', function () {
            var file = coverInput.files && coverInput.files[0];
            if (!file) return;
            coverPreview.src = URL.createObjectURL(file);
            coverPreview.hidden = false;
            if (coverPreviewEmpty) coverPreviewEmpty.hidden = true;
        });
    }

    var addScheduleBtn = document.getElementById('addScheduleBtn');
    var scheduleList = document.getElementById('scheduleList');
    var scheduleTemplate = document.getElementById('scheduleTemplate');
    var scheduleSummaryBody = document.getElementById('scheduleSummaryBody');
    var scheduleIndex = scheduleList ? scheduleList.querySelectorAll('.schedule-card').length : 1;

    function applyVatToggles(root) {
        (root || document).querySelectorAll('.vat-row').forEach(function (row) {
            var checkbox = row.querySelector('input[type="checkbox"]');
            var input = row.querySelector('input[type="number"]');
            if (!checkbox || !input) return;
            function sync() {
                input.disabled = !checkbox.checked;
                if (!checkbox.checked) input.value = '0';
                if (checkbox.checked && input.value === '0') input.value = '8';
            }
            checkbox.removeEventListener('change', sync);
            checkbox.addEventListener('change', sync);
            sync();
        });
    }

    function updateScheduleSummary() {
        if (!scheduleSummaryBody || !scheduleList) return;
        scheduleSummaryBody.innerHTML = '';
        scheduleList.querySelectorAll('.schedule-card').forEach(function (card, idx) {
            var sale = field(card, 'saleOpenDate');
            var departure = field(card, 'departureDate');
            var ret = field(card, 'returnDate');
            var close = field(card, 'bookingDeadline');
            var price = field(card, 'adultPrice');
            var tr = document.createElement('tr');
            tr.innerHTML =
                '<td>' + (idx + 1) + '</td>' +
                '<td>' + escapeHtml(sale ? sale.value : '') + '</td>' +
                '<td>' + escapeHtml(departure ? departure.value : '') + '</td>' +
                '<td>' + escapeHtml(ret ? ret.value : '') + '</td>' +
                '<td>' + escapeHtml(close ? close.value : '') + '</td>' +
                '<td>' + escapeHtml(price ? price.value : '') + '</td>' +
                '<td><button type="button" class="btn-link-button" data-show-schedule="' + card.getAttribute('data-schedule-index') + '">Xem chi tiết</button></td>';
            scheduleSummaryBody.appendChild(tr);
        });
    }

    if (addScheduleBtn && scheduleList && scheduleTemplate) {
        addScheduleBtn.addEventListener('click', function () {
            var html = scheduleTemplate.innerHTML
                .replace(/__INDEX__/g, String(scheduleIndex))
                .replace(/__NUMBER__/g, String(scheduleIndex + 1));
            var wrapper = document.createElement('div');
            wrapper.innerHTML = html.trim();
            var card = wrapper.firstElementChild;
            scheduleList.appendChild(card);
            if (seatSelect && seatSelect.value) {
                card.querySelectorAll('[data-max-participants]').forEach(function (input) { input.value = seatSelect.value; });
            }
            applyVatToggles(card);
            scheduleIndex++;
            updateScheduleSummary();
        });

        scheduleList.addEventListener('click', function (event) {
            var removeBtn = event.target.closest('[data-remove-schedule]');
            if (!removeBtn) return;
            removeBtn.closest('.schedule-card').remove();
            updateScheduleSummary();
        });

        scheduleList.addEventListener('input', updateScheduleSummary);
        scheduleList.addEventListener('change', updateScheduleSummary);
    }

    if (scheduleSummaryBody && scheduleList) {
        scheduleSummaryBody.addEventListener('click', function (event) {
            var btn = event.target.closest('[data-show-schedule]');
            if (!btn) return;
            var index = btn.getAttribute('data-show-schedule');
            var card = scheduleList.querySelector('.schedule-card[data-schedule-index="' + index + '"]');
            if (!card) return;
            card.scrollIntoView({ behavior: 'smooth', block: 'center' });
            card.classList.add('highlight-card');
            setTimeout(function () { card.classList.remove('highlight-card'); }, 1200);
        });
    }

    applyVatToggles(document);
    updateScheduleSummary();

    var optionalList = document.getElementById('optionalServiceList');
    var optionalTemplate = document.getElementById('optionalServiceTemplate');
    var addOptionalBtn = document.getElementById('addOptionalServiceBtn');

    if (optionalList && optionalTemplate && addOptionalBtn) {
        addOptionalBtn.addEventListener('click', function () {
            var wrapper = document.createElement('div');
            wrapper.innerHTML = optionalTemplate.innerHTML.trim();
            optionalList.appendChild(wrapper.firstElementChild);
        });

        optionalList.addEventListener('click', function (event) {
            var removeBtn = event.target.closest('[data-remove-optional]');
            if (!removeBtn) return;
            var rows = optionalList.querySelectorAll('.optional-row');
            if (rows.length > 1) {
                removeBtn.closest('.optional-row').remove();
            } else {
                removeBtn.closest('.optional-row').querySelectorAll('input').forEach(function (input) {
                    input.value = '';
                });
            }
        });
    }
});
