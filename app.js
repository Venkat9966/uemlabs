const modal = document.querySelector('#modal');
const modalTitle = document.querySelector('#modal-title');
const modalCopy = document.querySelector('#modal-copy');
const menuToggle = document.querySelector('.menu-toggle');
const mainNav = document.querySelector('.main-nav');

function openModal(type, course) {
  modalTitle.textContent = type === 'login' ? 'Welcome back' : course ? `Start ${course}` : 'Create your free account';
  modalCopy.textContent = type === 'login' ? 'Log in to continue your learning journey.' : course ? 'Create an account to save your progress and begin learning.' : 'Start learning practical endpoint management skills today.';
  modal.classList.add('open');
  modal.setAttribute('aria-hidden', 'false');
  document.querySelector('.modal input').focus();
}
function closeModal() {
  modal.classList.remove('open');
  modal.setAttribute('aria-hidden', 'true');
}

document.querySelectorAll('[data-action]').forEach((button) => {
  button.addEventListener('click', () => openModal(button.dataset.action));
});
document.querySelectorAll('[data-course]').forEach((button) => {
  button.addEventListener('click', () => openModal('signup', button.dataset.course));
});
document.querySelector('.modal-close').addEventListener('click', closeModal);
modal.addEventListener('click', (event) => { if (event.target === modal) closeModal(); });
document.addEventListener('keydown', (event) => { if (event.key === 'Escape') closeModal(); });
menuToggle.addEventListener('click', () => mainNav.classList.toggle('open'));
document.querySelectorAll('.main-nav a').forEach((link) => link.addEventListener('click', () => mainNav.classList.remove('open')));
document.querySelector('#auth-form').addEventListener('submit', (event) => {
  event.preventDefault();
  const submit = event.currentTarget.querySelector('button');
  submit.innerHTML = 'You’re on your way! ✓';
  submit.disabled = true;
  setTimeout(closeModal, 1200);
});
