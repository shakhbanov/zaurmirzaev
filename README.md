# zaurmirzaev.ru — taplink для Instagram

Лендинг-визитка для био Instagram @uromirzaev. Один экран, кнопки-карточки, мобильно-первичный, тёмная тема — авто, та же палитра, что и у doctor-mirzaev.ru.

## Что внутри

| | |
|---|---|
| `index.html` | один экран — аватар, имя, статы, CTA, карточки ссылок, расписание, карта, футер |
| `assets/css/styles.css` | дизайн-система, hover/touch-state'ы, dark mode |
| `assets/img/avatar.jpg` | портрет (скопирован из doctor-mirzaev.ru) |
| `assets/img/favicon.svg` | буква «З» сэндового цвета на тёмном teal |
| `CNAME` | `zaurmirzaev.ru` (для GitHub Pages) |
| `.nojekyll` | отключает Jekyll-обработку |
| `robots.txt`, `sitemap.xml`, `site.webmanifest` | стандартные production-файлы |

## Что отдаёт страница

**Hero:** портрет, «Заур *Мирзаев*», подпись «Уролог · К.М.Н. · Ростов-на-Дону», коротко о практике.

**Стат-полоска:** 4.9★ · 100+ операций · 2022 К.М.Н.

**Главный CTA:** «Записаться на видеоприём — 3 500 ₽» → `doctor-mirzaev.ru/online.html`.

**Связаться:** WhatsApp (с подготовленным текстом сообщения), телефон.

**Подробнее:** сайт врача, ProDoctorov, Instagram.

**Расписание:** Очный приём (Пт 14:00–20:00) + Онлайн (каждый день 10:00–21:00).

**Карта:** живой Yandex-виджет с ГКБ № 20 + кнопка «Маршрут».

**Footer:** © 2026, ссылка на основной сайт, 18+.

## Аналитика

В страницу встроен счётчик Yandex.Metrika (id `108756990`, тот же что на основном сайте) + цели по тапам через `data-action`:

- `tap_online` — клик «Записаться»
- `tap_wa` — WhatsApp
- `tap_phone` — звонок
- `tap_site` — переход на сайт
- `tap_prodoctorov` — ProDoctorov
- `tap_ig` — Instagram

Если хотите отдельный счётчик — поменяйте id в двух местах: `<script>` в `<head>` и в обработчике в `<script>` внизу `<body>`.

## Локальный просмотр

```bash
cd /root/zaurmirzaev
python3 -m http.server 8080
# http://localhost:8080
```

## Деплой на GitHub Pages

GitHub Pages позволяет один кастомный домен на репозиторий, поэтому **этот сайт нужен в отдельном репозитории** (не в `shakhbanov/mirzaev`).

```bash
cd /root/zaurmirzaev
git init -b main
git add -A
git commit -m "feat: initial taplink for zaurmirzaev.ru"

# Создать новый публичный репозиторий на GitHub:
gh repo create shakhbanov/zaurmirzaev --public --source=. --remote=origin --push

# Включить Pages в legacy-режиме на ветку main:
gh api -X POST repos/shakhbanov/zaurmirzaev/pages \
  -f 'build_type=legacy' \
  -f 'source[branch]=main' \
  -f 'source[path]=/'
```

## DNS для `zaurmirzaev.ru`

В Timeweb (или у регистратора) добавьте те же записи, что и для doctor-mirzaev.ru:

```
A     @    185.199.108.153
A     @    185.199.109.153
A     @    185.199.110.153
A     @    185.199.111.153
CNAME www  shakhbanov.github.io
```

После того как `dig +short zaurmirzaev.ru @8.8.8.8` начнёт отдавать IP-адреса GitHub:

```bash
gh api -X PUT repos/shakhbanov/zaurmirzaev/pages -F cname=zaurmirzaev.ru
# Подождать минут 10–30 пока выпустится сертификат Let's Encrypt:
gh api -X PUT repos/shakhbanov/zaurmirzaev/pages -F https_enforced=true
```
