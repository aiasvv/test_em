## Bash-скрипт и systemd для мониторинга процесса `test`

Проект содержит bash-скрипт и systemd-юниты для автоматического мониторинга процесса `test`. Скрипт запускается каждую минуту, проверяет состояние процесса и отправляет запрос на сервер мониторинга.

---

### Что делает

* Запускается автоматически каждую минуту через systemd-таймер.
* Если процесс `test` запущен:

  * Отправляется HTTPS-запрос на `https://test.com/monitoring/test/api`
  * Если PID процесса изменился — это считается перезапуском, и событие записывается в `/var/log/monitoring.log`
  * Если сервер недоступен — также делается запись в лог.
* Если процесс не найден — скрипт ничего не делает.

---

### Содержимое

* `test_em.sh` — основной bash-скрипт
* `test_em.service` — systemd unit-файл сервиса
* `test_em.timer` — systemd таймер (раз в минуту)

---

### Установка

```bash
# Копируем скрипт
sudo cp test_em.sh /usr/local/bin/test_em.sh
sudo chmod +x /usr/local/bin/test_em.sh

# Копируем systemd-файлы
sudo cp test_em.service /etc/systemd/system/
sudo cp test_em.timer /etc/systemd/system/

# Перезапускаем systemd и включаем таймер
sudo systemctl daemon-reload
sudo systemctl enable --now test_em.timer
```

---

### Проверка

```bash
# Проверить, что таймер активен
systemctl list-timers --all | grep test_em

# Посмотреть логи выполнения
journalctl -u test_em.service

# Лог-файл скрипта
tail -f /var/log/monitoring.log
```

---

### Ручной запуск

```bash
sudo bash /usr/local/bin/test_em.sh
```