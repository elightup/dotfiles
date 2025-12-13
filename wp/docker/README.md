# Tổng quan

Đây là 1 website WordPress chạy trên Docker, dùng để kiểm tra nhanh plugin, theme với các cấu hình khác nhau (do Docker cho phép chọn các phiên bản WordPress hay PHP khác nhau 1 cách dễ dàng).

Có 2 cách để chạy:

## Sử dụng Docker thuần tuý

- Cách này dùng [image wordpress](https://hub.docker.com/_/wordpress)
- Đã ánh xạ sẵn folder `wp-content` trên localhost vào thư mục `wp-content` trên container để có sẵn toàn bộ plugin và theme
- Để kiểm tra với phiên bản WordPress hay PHP nào thì chỉ cần thay `image` trong file `compose.yml`

### Cài đặt

Cần phải cài đặt [Docker Desktop](https://www.docker.com/products/docker-desktop/).

### Cách dùng

Để bắt đầu, chạy lệnh:

```bash
docker compose up -d
```

Rồi truy cập URL: `http://localhost:8080`.

Để tắt, chạy lệnh:

```bash
docker compose down
```

### Nhận xét

Ưu điểm:
- Dễ dàng thay đổi phiên bản của WordPress và PHP
- Mỗi khi thay đổi phiên bản của WordPress hay PHP thì dữ liệu của website không bị thay đổi, do chúng được ánh xạ tới các volume bên ngoài (nằm trên máy local)

Nhược điểm: phải cài WordPress lần đầu

Để chạy site thứ 2 thì làm các bước sau:
	- Copy file `compose.yml` sang 1 folder mới
	- Thay đổi port và volume để tránh trùng cổng và volume chứa dữ liệu của site cũ

## Sử dụng `@wordpress/env`

[Tham khảo](https://developer.wordpress.org/block-editor/reference-guides/packages/packages-env/)

### Cài đặt

Cần phải cài đặt:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- NodeJS
- Git

### Cách dùng

Để bắt đầu, chạy lệnh:

```bash
wp-env start
```

Truy cập vào website tại địa chỉ: `http://localhost:8888`. Package này tự động cài đặt WordPress với các thông tin như sau:

```
Username: admin
Password: password
```

Để tắt, chạy lệnh:

```bash
wp-env stop
```

### Nhận xét

Ưu điểm:
- Là môi trường được WordPress khuyến nghị
- Dễ dàng thay đổi phiên bản của WordPress và PHP
- Mỗi khi thay đổi phiên bản của WordPress hay PHP thì dữ liệu của website không bị thay đổi, do chúng được ánh xạ tới các volume bên ngoài (nằm trên máy local)
- Cài đặt sẵn WordPress, tiết kiệm thời gian
- Có nhiều tuỳ chọn cấu hình hơn, đặt trong file `.wp-env.json`
- Khi chạy site thứ 2 thì dữ liệu (volume) được tự động tạo riêng

Nhược điểm: khi chạy site thứ 2 thì phải download image WordPress lại, khá tốn ổ cứng.

Để chạy site thứ 2 thì làm các bước sau:
	- Copy file `.wp-env.json` sang 1 folder mới
	- Thay đổi port để tránh trùng cổng của site cũ. `wp-env` tự động tạo volume riêng cho từng site nên không phải tạo volume mới
