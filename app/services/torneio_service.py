"""Dados estáticos do torneio (fases e chaveamento), sem acesso ao banco."""

def listar_fases() -> list[dict]:
    return [
        {
            "fase_id": 1,
            "nome_fase": "Fase de Grupos",
            "descricao": "12 grupos. Classificam-se os dois melhores e os oito melhores terceiros.",
        },
        {
            "fase_id": 2,
            "nome_fase": "Dezesseis-avos de Final",
            "descricao": "Primeira eliminatória com 32 seleções em jogo único.",
        },
        {
            "fase_id": 3,
            "nome_fase": "Oitavas de Final",
            "descricao": "16 vencedores seguem no chaveamento.",
        },
        {
            "fase_id": 4,
            "nome_fase": "Quartas de Final",
            "descricao": "8 seleções disputam vaga nas semifinais.",
        },
        {
            "fase_id": 5,
            "nome_fase": "Semifinal",
            "descricao": "4 seleções disputam vaga na final.",
        },
        {
            "fase_id": 6,
            "nome_fase": "Disputa do 3º Lugar",
            "descricao": "Partida entre os derrotados nas semifinais.",
        },
        {"fase_id": 7, "nome_fase": "Final", "descricao": "Partida decisiva para definição do campeão."},
    ]


def listar_chaveamento() -> list[str]:
    return [
        "2A x 2B",
        "1E x 3A/B/C/D/F",
        "1F x 2C",
        "1C x 2F",
        "1I x 3C/D/F/G/H",
        "2E x 2I",
        "1A x 3C/E/F/H/I",
        "1L x 3E/H/I/J/K",
        "1D x 3B/E/F/I/J",
        "1G x 3A/E/H/I/J",
        "2K x 2L",
        "1H x 2J",
        "1B x 3E/F/G/I/J",
        "1J x 2H",
        "1K x 3D/E/I/J/L",
        "2D x 2G",
    ]

