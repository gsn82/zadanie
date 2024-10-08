README
Описание проекта
Этот проект представляет собой Docker-контейнер, который собирает и запускает два приложения: одно написано на Go, а другое на C++. Используя удобный интерфейс выбора, пользователи могут запускать одно из двух приложений в зависимости от установленной переменной окружения.

Структура проекта
Dockerfile: Основной файл для сборки контейнера.
main.go: Основной код приложения на Go.
main.cpp: Основной код приложения на C++.
Использование
Предварительные требования
Docker должен быть установлен на вашей системе.
Сборка контейнера
Чтобы собрать Docker-образ, выполните следующую команду в корневом каталоге проекта:

bash
docker build -t myapp .
Запуск контейнера
После успешной сборки образа запустите контейнер с помощью следующей команды:

bash
docker run --rm myapp
По умолчанию будет запущено приложение на C++. Если вы хотите запустить приложение на Go, установите переменную окружения DEFAULT_APP в go следующим образом:

bash
docker run --rm -e DEFAULT_APP=go myapp

Структура Dockerfile
Сборка приложений:
Приложение на Go собирается в стадии builder2.
Приложение на C++ собирается в стадии builder1.

Финальный контейнер:
Используется образ Debian для запуска собранных приложений.
Оба приложения копируются из этапов сборки в финальный образ.

Параметры сборки
GCC_VERSION: Версия образа для сборки C++ приложения (по умолчанию 12-slim).
GOLANG_VERSION: Версия образа для сборки Go приложения (по умолчанию latest).
ALPINE_VERSION: Версия Debian для финального образа (по умолчанию 12-slim).
DEFAULT_APP: Переменная для выбора приложения по умолчанию (по умолчанию cpp).
Заключение
Этот проект обеспечивает простую и удобную платформу для сборки и запуска приложений на Go и C++ в одном контейнере с использованием Docker. Вы можете легко настраивать и расширять его в зависимости от ваших потребностей.
