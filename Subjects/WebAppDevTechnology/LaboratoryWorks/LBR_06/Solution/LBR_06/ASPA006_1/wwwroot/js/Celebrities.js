const buttons = document.querySelectorAll(".imgButton");

buttons.forEach(button => {
    button.addEventListener("click", async function() {
        try {
            const img = this.querySelector("img").getAttribute("src").split('/').pop();
            const response = await fetch(`/api/getLocalLe/${img}`);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const resultText = await response.text(); 
            
            const textBlock = document.getElementById('result');
            textBlock.textContent = resultText; 
        }
        catch (error) {
            console.error('Error:', error);
            document.getElementById('result').textContent = 'Ошибка загрузки данных';
        }
    });
});