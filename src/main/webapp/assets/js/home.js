const menuBtn = document.getElementById('menuBtn');
const mainNav = document.getElementById('mainNav');
const scrollTop = document.getElementById('scrollTop');
const searchType = document.getElementById('searchType');

if (menuBtn && mainNav) {
    menuBtn.addEventListener('click', function () {
        mainNav.classList.toggle('open');
    });
}

document.querySelectorAll('.tab-btn').forEach(function (button) {
    button.addEventListener('click', function () {
        document.querySelectorAll('.tab-btn').forEach(function (item) {
            item.classList.remove('active');
        });
        button.classList.add('active');
        if (searchType) searchType.value = button.dataset.tab;
    });
});

document.querySelectorAll('.filter-btn').forEach(function (button) {
    button.addEventListener('click', function () {
        const region = button.dataset.region;

        document.querySelectorAll('.filter-btn').forEach(function (item) {
            item.classList.remove('active');
        });
        button.classList.add('active');

        document.querySelectorAll('.package-card').forEach(function (card) {
            card.style.display = region === 'all' || card.dataset.region === region ? 'block' : 'none';
        });
    });
});

window.addEventListener('scroll', function () {
    if (!scrollTop) return;
    scrollTop.classList.toggle('show', window.scrollY > 400);
});

if (scrollTop) {
    scrollTop.addEventListener('click', function () {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}
