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

    const toast = document.getElementById('successToast');
    const dismissButton = document.querySelector('[data-dismiss-toast]');
    if (toast && dismissButton) {
        dismissButton.addEventListener('click', function () {
            toast.remove();
        });
    }
});
