1. В целом все понятно. Жду с нетерпением раскрытия темы foreign keys.

2. Добавил опять же две таблицы, likes и likes_type, по тому же принципу, что и медиа,
чтобы иметь возможность сортировать линки на объекты по виду этих объектов.
Photo, video, sound, message, profile.

3. Нагенерил данных. likes_types и media_types - 5 и 3 элемента, остальные по 100.
У сервиса явные проблемы с генерацией случайной последовательности из имеющихся
в другой таблице id - почему-то берет принципиально подряд.
Большой конечный файл с генерацией всей базы данных целиком мой mysql не принял,
ругался на каждом шагу, а таблицы раздельно по очереди съел.

4. Форму заполнил)

