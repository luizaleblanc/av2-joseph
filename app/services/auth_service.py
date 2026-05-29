"""Regras e queries de autenticação/perfil (cadastro, login e recuperação)."""

import pymysql

from app.database.connection import conectaBanco


def cadastro_usuario(dados: dict) -> dict:
    nome = dados["nome"]
    email = dados["email"]
    senha = dados["senha"]
    tipo = dados.get("tipo_usuario", "Telespectador")
    pergunta = dados["pergunta_seguranca"]
    resposta = dados["resposta_seguranca"]

    bd = conectaBanco()
    cursor = bd.cursor()
    try:
        sql = "INSERT INTO usuario (nome, email, senha, tipo_usuario, pergunta_seguranca, resposta_seguranca) VALUES (%s, %s, %s, %s, %s, %s);"
        cursor.execute(sql, (nome, email, senha, tipo, pergunta, resposta))
        bd.commit()
        return {"mensagem": "Usuário cadastrado com sucesso!", "code": 201}
    except pymysql.MySQLError:
        return {"mensagem": "Erro ao cadastrar. Email já cadastrado no sistema.", "code": 400}
    finally:
        bd.close()


def login_usuario(dados: dict) -> dict:
    email = dados["email"]
    senha = dados["senha"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT id_usuario, nome, email, tipo_usuario FROM usuario WHERE email = %s AND senha = %s;"
    cursor.execute(sql, (email, senha))
    usuario = cursor.fetchone()
    bd.close()

    if usuario:
        return {
            "code": 200,
            "id_usuario": usuario[0],
            "nome": usuario[1],
            "email": usuario[2],
            "tipo_usuario": usuario[3],
        }
    return {"mensagem": "Credenciais incorretas.", "code": 401}


def buscar_pergunta_seguranca(dados: dict) -> dict:
    email = dados["email"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT pergunta_seguranca FROM usuario WHERE email = %s;"
    cursor.execute(sql, (email,))
    resultado = cursor.fetchone()
    bd.close()

    if resultado:
        return {"pergunta_seguranca": resultado[0], "code": 200}
    return {"mensagem": "Email não encontrado.", "code": 404}


def alterar_senha_por_recuperacao(dados: dict) -> dict:
    email = dados["email"]
    resposta = dados["resposta_seguranca"]
    nova_senha = dados["nova_senha"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "UPDATE usuario SET senha = %s WHERE email = %s AND resposta_seguranca = %s;"
    cursor.execute(sql, (nova_senha, email, resposta))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Senha redefinida com sucesso!", "code": 200}
    return {"mensagem": "Resposta de segurança inválida.", "code": 400}


def atualizar_perfil_usuario(dados: dict) -> dict:
    id_usuario = dados["id_usuario"]
    nome = dados["nome"]
    senha = dados["senha"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "UPDATE usuario SET nome = %s, senha = %s WHERE id_usuario = %s;"
    cursor.execute(sql, (nome, senha, id_usuario))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Dados do perfil atualizados!", "code": 200}
    return {"mensagem": "Nenhuma alteração foi realizada.", "code": 400}

