const toast = document.querySelector('#toast');
function showToast(message) { toast.textContent = message; toast.classList.add('show'); setTimeout(() => toast.classList.remove('show'), 2600); }
document.querySelectorAll('[data-action="lesson"]').forEach((button) => button.addEventListener('click', () => showToast('Lesson opened — your progress is saved.')));
document.querySelector('#browse-button').addEventListener('click', () => { window.location.href = 'index.html#courses'; });
document.querySelector('#account-button').addEventListener('click', () => showToast('Account settings will be available after authentication is connected.'));
