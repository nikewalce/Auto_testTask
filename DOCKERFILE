# Используем официальный Python-образ в качестве базового
FROM python:3.10-slim

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . .

# Устанавливаем Google Chrome и ChromeDriver для Selenium
RUN apt-get update && \
    apt-get install -y wget curl unzip chromium-driver && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем зависимости проекта
RUN pip install --no-cache-dir -r requirements.txt

# Устанавливаем Allure для генерации отчетов
RUN curl -o allure-2.32.2.zip -L "https://github.com/allure-framework/allure2/releases/download/2.32.2/allure-2.32.2.zip" && \
    tar -xzf allure-2.32.2.zip && \
    mv allure-2.32.2 /opt/allure && \
    ln -s /opt/allure/bin/allure /usr/bin/allure && \
    rm allure-2.32.2.zip

# Переменная окружения для корректной работы ChromeDriver
ENV PATH="/usr/local/bin:/usr/bin:/opt/allure/bin:${PATH}"

# Запуск тестов и сохранение результатов Allure
CMD ["sh", "-c", "pytest --alluredir=allure-results && allure serve allure-results"]
