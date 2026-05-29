"""Regras e queries de seleções (CRUD) usando MySQL."""

from app.database.connection import conectaBanco


def listar_selecoes() -> list[dict]:
    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT id_selecao, nome, grupo FROM selecao;"
    cursor.execute(sql)
    resultado = cursor.fetchall()

    selecoes = []
    for sel in resultado:
        selecoes.append(
            {"idSelecao": sel[0], "nomeSelecao": sel[1], "grupoSelecao": sel[2]}
        )
    bd.close()
    return selecoes


def criar_selecao(dados: dict) -> dict:
    nome = dados["nomeSelecao"]
    grupo = dados["grupoSelecao"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "INSERT INTO selecao (nome, grupo) VALUES (%s, %s);"
    cursor.execute(sql, (nome, grupo))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Seleção cadastrada com sucesso!", "code": 200}
    return {"mensagem": "Erro ao cadastrar seleção.", "code": 400}


def atualizar_selecao(dados: dict) -> dict:
    id_selecao = dados["idSelecao"]
    nome = dados["nomeSelecao"]
    grupo = dados["grupoSelecao"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "UPDATE selecao SET nome = %s, grupo = %s WHERE id_selecao = %s;"
    cursor.execute(sql, (nome, grupo, id_selecao))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Seleção atualizada com sucesso!", "code": 200}
    return {"mensagem": "Seleção não localizada ou sem alterações.", "code": 400}


def remover_selecao(dados: dict) -> dict:
    id_selecao = dados["idSelecao"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "DELETE FROM selecao WHERE id_selecao = %s;"
    cursor.execute(sql, (id_selecao,))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Seleção removida com sucesso!", "code": 200}
    return {"mensagem": "Seleção não localizada.", "code": 400}

