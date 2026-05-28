"""Conexão com o MySQL (camada de infraestrutura/database)."""

import os

import pymysql


def conectaBanco():
    return pymysql.connect(
        database="copado_mundo",
        host="localhost",
        user="root",
        passwd=os.getenv("MYSQL_PASSWORD", "annyacernitrov15"),
        charset="utf8mb4",
    )

