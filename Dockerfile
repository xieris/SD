# /Users/linx/Documents/Code/meta/wiki/.venv/lib/python3.7/site-packages/mkdocs/contrib/search/search_index.py
# /Users/linx/Documents/Code/meta/wiki/.venv/lib/python3.7/site-packages/mkdocs/contrib/search/templates/search/lunr.js

FROM python:3.8 as build-stage
# FROM python:3.8-slim as build-stage

WORKDIR /app

COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# add Chinese Search Support
COPY ./chinese_search_support/search_index.py /usr/local/lib/python3.8/site-packages/mkdocs/contrib/search/search_index.py
COPY ./chinese_search_support/lunr.js /usr/local/lib/python3.8/site-packages/mkdocs/contrib/search/templates/search/lunr.js

WORKDIR /app/mkdocs

EXPOSE 8000

RUN mkdocs build


FROM nginx:latest as production-stage
COPY --from=build-stage /app/mkdocs/site /usr/share/nginx/html
EXPOSE 80 
CMD ["nginx", "-g", "daemon off;"]