#!/bin/sh

# تنظیم مستقیم کلیدها به‌صورت متغیرهای محیطی و اجرای دستور
AWS_ACCESS_KEY_ID="7kGzXRsagvzEdzMOStCb" \
AWS_SECRET_ACCESS_KEY="sdPKn0msq0lDxNAWHjBGWzGwpwGHO88Cbf25dGET" \
aws s3 ls s3://back-up/ --endpoint-url=http://minio:9000

