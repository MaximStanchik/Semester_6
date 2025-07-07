document.addEventListener('DOMContentLoaded', () => {
    const grid = document.getElementById('celebrities-grid');
    const eventsContainer = document.getElementById('events-container');
    const eventsList = document.getElementById('events-list');
    const eventCeleb = document.getElementById('event-celebrity')

    const URI = "http://localhost:5164";

    function loadCelebrities() {
        fetch(`${URI}/api/celebrities`)
            .then(response => response.json())
            .then(data => {
                data.forEach(celebrity => {
                    const container = document.createElement('div');
                    container.className = 'image-container';

                    const img = document.createElement('img');
                    img.src = `${URI}/api/celebrities/photo/${celebrity.reqPhotoPath}`;
                    img.alt = celebrity.fullName;
                    img.onclick = () => loadEvents(celebrity.id, celebrity.fullName);

                    container.appendChild(img);
                    grid.appendChild(container);
                });
            })
            .catch(error => console.error('Error fetching celebrities:', error));
    }

    window.loadEvents = function (id, name) {
        eventsContainer.style.display = 'block';
        eventsList.innerHTML = '';
        eventCeleb.innerHTML = name;

        fetch(`${URI}/api/lifeevents/celebrities/${id}`)
            .then(response => response.json())
            .then(data => {
                data.forEach(event => {
                    const listItem = document.createElement('li');
                    listItem.textContent = `${event.date}: ${event.description}`;
                    eventsList.appendChild(listItem);
                });
            })
            .catch(error => console.error('Error fetching events:', error));
    };

    loadCelebrities();
});