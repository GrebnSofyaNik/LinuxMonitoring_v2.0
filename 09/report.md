## Содержание

- [Содержание](#содержание)
- [1. Создание bash-скриптов и изменение конфигурационных файлов ](#1-создание-bash-скриптов-и-изменение-конфигурационных-файлов-)
- [2. Проведение тестов ](#2-проведение-тестов-)

## 1. Создание bash-скриптов и изменение конфигурационных файлов <br/>

* Напишем bash-скрипт `get_info.sh`, который собирает информацию по базовым метрикам системы (ЦПУ, оперативная память, жесткий диск (объем)). <br/>
* Скрипт формирует html-страницу `index.html` по формату Prometheus, которую будет отдавать nginx. <br/>
* Страница обновляется внутри bash-скрипта `main.sh` в цикле каждые 3 сек. <br/>
* Внесем изменения в конфигурационный файл `nginx.conf` <br/>
    ```sh
  server {
		listen 8080;
		location / {
			root /usr/share/nginx/html;
			index index.html;
		}
	}
    ```
* Внесем изменения в файл `prometheus.yml` <br/>
    ```sh
    - job_name: 'my_node'
    metrics_path: /
    static_configs:
      - targets: ['localhost:8080']
    ```
* Запустим скрипт и проверим, что по адресу `http://localhost:9090/` добавились новые метрики <br/>
    ![part_9](./screenshots/my_node.jpg)<br/>

## 2. Проведение тестов <br/>

* Запустим bash-скрипт из `Part 2`<br/>
* Проверим результаты работы
    ![part_9](./screenshots/cpu_usage_1.jpg)<br/>
    ![part_9](./screenshots/mem_used_1.jpg)<br/>
    ![part_9](./screenshots/mem_free_1.jpg)<br/>
    ![part_9](./screenshots/ram_used_1.jpg)<br/>
* Запустим команду
    ```sh
    $ stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 60s
    ```
* Проверим результаты работы
    ![part_9](./screenshots/cpu_usage_2.jpg)<br/>
    ![part_9](./screenshots/ram_used_2.jpg)<br/>