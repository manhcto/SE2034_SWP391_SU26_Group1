document.addEventListener('DOMContentLoaded', function () {
    const tabs = document.querySelectorAll('[data-search-target]');
    const forms = document.querySelectorAll('.home-search-form');
    const scrollTopButton = document.getElementById('scrollTop');
    const today = new Date().toISOString().slice(0, 10);

    tabs.forEach(function (tab) {
        tab.addEventListener('click', function () {
            tabs.forEach(function (item) {
                const active = item === tab;
                item.classList.toggle('active', active);
                item.setAttribute('aria-selected', String(active));
            });

            forms.forEach(function (form) {
                const active = form.id === tab.dataset.searchTarget;
                form.classList.toggle('active', active);
                form.hidden = !active;
            });
        });
    });

    document.querySelectorAll('[data-min-today]').forEach(function (input) {
        input.min = today;
    });

    const checkIn = document.querySelector('input[name="checkIn"]');
    const checkOut = document.querySelector('input[name="checkOut"]');
    if (checkIn && checkOut) {
        checkIn.addEventListener('change', function () {
            checkOut.min = checkIn.value || today;
            if (checkOut.value && checkOut.value <= checkIn.value) {
                checkOut.value = '';
            }
        });
    }

    window.addEventListener('scroll', function () {
        if (scrollTopButton) {
            scrollTopButton.classList.toggle('show', window.scrollY > 500);
        }
    }, { passive: true });

    if (scrollTopButton) {
        scrollTopButton.addEventListener('click', function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }

    document.querySelectorAll('.tour-rail-wrap').forEach(function (wrap) {
        const rail = wrap.querySelector('[data-tour-rail]');
        const prev = wrap.querySelector('[data-rail-prev]');
        const next = wrap.querySelector('[data-rail-next]');
        if (!rail) return;
        const scrollRail = function (direction) {
            const firstCard = rail.querySelector('.home-tour-card');
            const distance = firstCard ? firstCard.getBoundingClientRect().width + 8 : rail.clientWidth * 0.8;
            rail.scrollBy({ left: direction * distance, behavior: 'smooth' });
        };
        if (prev) prev.addEventListener('click', function () { scrollRail(-1); });
        if (next) next.addEventListener('click', function () { scrollRail(1); });
    });

    const toast = document.getElementById('successToast');
    const dismissButton = document.querySelector('[data-dismiss-toast]');
    if (toast && dismissButton) {
        dismissButton.addEventListener('click', function () {
            toast.remove();
        });
    }
});
