FROM node:14-alpine

#copies 
WORKDIR /frontend

COPY package*.json /frontend/

RUN npm install

COPY . /frontend/

CMD npm start
