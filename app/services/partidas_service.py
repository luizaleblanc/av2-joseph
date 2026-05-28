"""Regras e queries de partidas (CRUD e listagem detalhada) usando MySQL."""

from app.database.connection import conectaBanco


def listar_partidas_detalhada() -> list[dict]:
    bd = conectaBanco()
    cursor = bd.cursor()
    sql = """SELECT p.id_partidas, p.data, s1.nome AS selecao_casa, s2.nome AS selecao_visitante, p.placar_casa, p.placar_visitante
            FROM partidas p
            JOIN selecao s1 ON p.id_selecao_casa_fk = s1.id_selecao
            JOIN selecao s2 ON p.id_selecao_visitante_fk = s2.id_selecao;"""
    cursor.execute(sql)
    resultado = cursor.fetchall()

    listaPartidas = []
    for part in resultado:
        listaPartidas.append(
            {
                "idPartida": part[0],
                "dataPartida": str(part[1]),
                "selecaoCasa": part[2],
                "selecaoVisitante": part[3],
                "placarCasa": part[4],
                "placarVisitante": part[5],
            }
        )
    bd.close()
    return listaPartidas


def criar_partida(dados: dict) -> dict:
    data = dados["dataPartida"]
    placarCasa = dados["placarSelecaoCasa"]
    placarVisitante = dados["placarSelecaoVisitante"]
    idSelecaoCasa = dados["idSelecaoCasa"]
    idSelecaoVisitante = dados["idSelecaoVisitante"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "INSERT INTO partidas (data, placar_casa, placar_visitante, id_selecao_casa_fk, id_selecao_visitante_fk) VALUES (%s, %s, %s, %s, %s);"
    cursor.execute(
        sql, (data, placarCasa, placarVisitante, idSelecaoCasa, idSelecaoVisitante)
    )
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Partida registrada com sucesso!", "code": 200}
    return {"mensagem": "Erro ao registrar partida.", "code": 400}


def atualizar_partida(dados: dict) -> dict:
    id_partida = dados["idPartida"]
    dataPartida = dados["dataPartida"]
    placarCasa = dados["placarSelecaoCasa"]
    placarVisitante = dados["placarSelecaoVisitante"]
    idSelecaoCasa = dados["idSelecaoCasa"]
    idSelecaoVisitante = dados["idSelecaoVisitante"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = """UPDATE partidas SET data = %s, placar_casa = %s, placar_visitante = %s, id_selecao_casa_fk = %s, id_selecao_visitante_fk = %s
            WHERE id_partidas = %s;"""
    cursor.execute(
        sql,
        (
            dataPartida,
            placarCasa,
            placarVisitante,
            idSelecaoCasa,
            idSelecaoVisitante,
            id_partida,
        ),
    )
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Partida atualizada com sucesso!", "code": 200}
    return {"mensagem": "Partida não localizada ou sem alterações.", "code": 400}


def remover_partida(dados: dict) -> dict:
    id_partida = dados["idPartida"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "DELETE FROM partidas WHERE id_partidas = %s;"
    cursor.execute(sql, (id_partida,))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Partida removida com sucesso!", "code": 200}
    return {"mensagem": "Partida não localizada.", "code": 400}

