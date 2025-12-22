<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loadstring Generator</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }
        body {
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 800px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        h1 {
            color: #fff;
            font-size: 2.5rem;
            margin-bottom: 10px;
            background: linear-gradient(90deg, #00dbde, #fc00ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        .subtitle {
            color: #a0a0a0;
            font-size: 1.1rem;
        }
        .input-section {
            margin-bottom: 25px;
        }
        label {
            display: block;
            color: #fff;
            margin-bottom: 10px;
            font-weight: 600;
            font-size: 1.1rem;
        }
        .input-group {
            display: flex;
            gap: 10px;
        }
        input {
            flex: 1;
            padding: 15px 20px;
            background: rgba(255, 255, 255, 0.07);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: #fff;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        input:focus {
            outline: none;
            border-color: #00dbde;
            box-shadow: 0 0 0 3px rgba(0, 219, 222, 0.2);
        }
        input::placeholder {
            color: #888;
        }
        .btn {
            padding: 15px 25px;
            background: linear-gradient(90deg, #00dbde, #fc00ff);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
        }
        .btn:active {
            transform: translateY(0);
        }
        .generate-btn {
            background: linear-gradient(90deg, #00dbde, #0099ff);
        }
        .output-section {
            margin-top: 30px;
        }
        .output-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .output-actions {
            display: flex;
            gap: 10px;
        }
        .action-btn {
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }
        .action-btn:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        .copy-btn {
            background: linear-gradient(90deg, #4CAF50, #45a049);
        }
        .clear-btn {
            background: linear-gradient(90deg, #f44336, #d32f2f);
        }
        textarea {
            width: 100%;
            height: 200px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: #fff;
            font-size: 1rem;
            font-family: 'Consolas', 'Monaco', monospace;
            resize: none;
            transition: all 0.3s ease;
        }
        textarea:focus {
            outline: none;
            border-color: #00dbde;
        }
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            background: linear-gradient(90deg, #4CAF50, #45a049);
            color: white;
            border-radius: 8px;
            display: none;
            align-items: center;
            gap: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            z-index: 1000;
        }
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .input-group {
                flex-direction: column;
            }
            .btn {
                width: 100%;
            }
            .output-actions {
                flex-direction: column;
            }
            .action-btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-code"></i> Loadstring Generator</h1>
            <p class="subtitle">Convert any raw script URL into a loadstring for Roblox</p>
        </div>

        <div class="input-section">
            <label for="urlInput"><i class="fas fa-link"></i> Enter Raw Script URL:</label>
            <div class="input-group">
                <input type="text" id="urlInput" placeholder="https://raw.githubusercontent.com/shakar60/repo/main/script.lua">
                <button class="btn generate-btn" id="generateBtn">
                    <i class="fas fa-bolt"></i> Generate
                </button>
            </div>
        </div>

        <div class="output-section">
            <div class="output-header">
                <label><i class="fas fa-terminal"></i> Generated Loadstring:</label>
                <div class="output-actions">
                    <button class="action-btn copy-btn" id="copyBtn">
                        <i class="fas fa-copy"></i> Copy
                    </button>
                    <button class="action-btn clear-btn" id="clearBtn">
                        <i class="fas fa-trash"></i> Clear
                    </button>
                </div>
            </div>
            <textarea id="outputText" placeholder="Your loadstring will appear here..." readonly></textarea>
        </div>
    </div>

    <div class="notification" id="notification">
        <i class="fas fa-check-circle"></i>
        <span id="notificationText">Copied to clipboard!</span>
    </div>

    <script>
        const urlInput = document.getElementById('urlInput');
        const generateBtn = document.getElementById('generateBtn');
        const outputText = document.getElementById('outputText');
        const copyBtn = document.getElementById('copyBtn');
        const clearBtn = document.getElementById('clearBtn');
        const notification = document.getElementById('notification');
        const notificationText = document.getElementById('notificationText');

        function generateLoadstring() {
            const url = urlInput.value.trim();
            
            if (!url) {
                showNotification('Please enter a URL!', 'error');
                return;
            }

            if (!url.startsWith('http')) {
                showNotification('Please enter a valid URL', 'error');
                return;
            }

            const loadstring = `loadstring(game:HttpGet("${url}", true))()`;
            outputText.value = loadstring;
            outputText.select();
            showNotification('Loadstring generated!', 'success');
        }

        function copyToClipboard() {
            if (!outputText.value) {
                showNotification('Nothing to copy!', 'error');
                return;
            }
            outputText.select();
            document.execCommand('copy');
            showNotification('Copied to clipboard!', 'success');
        }

        function clearAll() {
            urlInput.value = '';
            outputText.value = '';
            showNotification('Cleared!', 'info');
        }

        function showNotification(message, type) {
            notificationText.textContent = message;
            if (type === 'error') {
                notification.style.background = 'linear-gradient(90deg, #f44336, #d32f2f)';
            } else if (type === 'success') {
                notification.style.background = 'linear-gradient(90deg, #4CAF50, #45a049)';
            } else {
                notification.style.background = 'linear-gradient(90deg, #2196F3, #1976D2)';
            }
            notification.style.display = 'flex';
            setTimeout(() => {
                notification.style.display = 'none';
            }, 3000);
        }

        generateBtn.addEventListener('click', generateLoadstring);
        copyBtn.addEventListener('click', copyToClipboard);
        clearBtn.addEventListener('click', clearAll);

        urlInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                generateLoadstring();
            }
        });
    </script>
</body>
</html>
