$(document).ready(async () => {
    await fetch('/api/cel', {
        method: 'GET',
        headers: { 'Accept': 'application/json', }
    })
        .then(res => res.json())
        .then(data => {
            const customImg = $('<img class="custom-image" src="/api/cel/photo/default.png">');
            customImg.click(() => {
                window.location.href = '/new';
            });
            $("#container").append(customImg);

            data.forEach(element => {
                const img = $(`<img class="photo-event" src="/api/cel/photo/${element.ReqPhotoPath}">`);

                img.click(() => {
                    window.location.href = `/Celebrities/Details/${element.Id}`;
                });

                $("#container").append(img);
            });
        })
})