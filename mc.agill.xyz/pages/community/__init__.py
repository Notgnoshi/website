import json
from pathlib import Path

players = Path(__file__).resolve().parent.joinpath('players.json')

with open(players, 'r') as f:
    PLAYERS = json.load(f)
