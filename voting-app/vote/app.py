from flask import Flask, render_template, request, make_response, g
from redis import Redis
from rediscluster import RedisCluster
import os
import socket
import random
import json
import logging

option_a = os.getenv('OPTION_A', "Cats")
option_b = os.getenv('OPTION_B', "Dogs")
hostname = socket.gethostname()

app = Flask(__name__)

gunicorn_error_logger = logging.getLogger('gunicorn.error')
app.logger.handlers.extend(gunicorn_error_logger.handlers)
app.logger.setLevel(logging.INFO)

def get_redis():
    if not hasattr(g, 'redis'):
        startup_nodes = [
            {'host': 'redis-node-1', 'port': 6379},
            {'host': 'redis-node-2', 'port': 6379},
            {'host': 'redis-node-3', 'port': 6379},
            {'host': 'redis-node-4', 'port': 6379},
            {'host': 'redis-node-5', 'port': 6379},
            {'host': 'redis-node-0', 'port': 6379},
        ]
        g.redis = RedisCluster(startup_nodes=startup_nodes, decode_responses=True, socket_timeout=5, password='yourpassword')
    return g.redis

@app.route("/", methods=['POST','GET'])
def hello():
    voter_id = request.cookies.get('voter_id')
    if not voter_id:
        voter_id = hex(random.getrandbits(64))[2:-1]

    vote = None

    if request.method == 'POST':
        redis = get_redis()
        vote = request.form['vote']
        app.logger.info('Received vote for %s', vote)
        data = json.dumps({'voter_id': voter_id, 'vote': vote})
        redis.rpush('votes', data)

    resp = make_response(render_template(
        'index.html',
        option_a=option_a,
        option_b=option_b,
        hostname=hostname,
        vote=vote,
    ))
    resp.set_cookie('voter_id', voter_id)
    return resp


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True, threaded=True)
