"""Regras e queries de jogadores (CRUD) usando MySQL."""

from app.database.connection import conectaBanco


def listar_jogadores() -> list[dict]:
    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "SELECT id_jogador, nome, posicao, id_selecao_fk FROM jogador;"
    cursor.execute(sql)
    resultado = cursor.fetchall()

    jogadores = []
    for jog in resultado:
        jogadores.append(
            {
                "idJogador": jog[0],
                "nomeJogador": jog[1],
                "posicaoJogador": jog[2],
                "idSelecaoFk": jog[3],
            }
        )
    bd.close()
    return jogadores


def criar_jogador(dados: dict) -> dict:
    nome = dados["nomeJogador"]
    posicao = dados["posicaoJogador"]
    idSelecao = dados["idSelecaoFk"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "INSERT INTO jogador (nome, posicao, id_selecao_fk) VALUES (%s, %s, %s);"
    cursor.execute(sql, (nome, posicao, idSelecao))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Jogador cadastrado com sucesso!", "code": 200}
    return {"mensagem": "Erro ao cadastrar jogador.", "code": 400}


def atualizar_jogador(dados: dict) -> dict:
    id_jogador = dados["idJogador"]
    nome = dados["nomeJogador"]
    posicao = dados["posicaoJogador"]
    id_selecao_fk = dados["idSelecaoFk"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "UPDATE jogador SET nome = %s, posicao = %s, id_selecao_fk = %s WHERE id_jogador = %s;"
    cursor.execute(sql, (nome, posicao, id_selecao_fk, id_jogador))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Dados do jogador atualizados!", "code": 200}
    return {"mensagem": "Jogador não localizado ou sem alterações.", "code": 400}


def remover_jogador(dados: dict) -> dict:
    id_jogador = dados["idJogador"]

    bd = conectaBanco()
    cursor = bd.cursor()
    sql = "DELETE FROM jogador WHERE id_jogador = %s;"
    cursor.execute(sql, (id_jogador,))
    bd.commit()
    resultado = cursor.rowcount
    bd.close()

    if resultado > 0:
        return {"mensagem": "Jogador removido com sucesso!", "code": 200}
    return {"mensagem": "Jogador não localizado.", "code": 400}

