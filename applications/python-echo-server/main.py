#!/usr/bin/env python3

import os
import logging

from paste.translogger import TransLogger
from waitress import serve
from flask import Flask, jsonify, request

# Get port from env variable or default to 8080
HOST = os.environ.get("HOST", "0.0.0.0")
PORT = os.environ.get("PORT", "8080")

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def create_app():
  app = Flask(__name__)

  @app.route("/")
  def root():
    return "Hey!", 200

  @app.route("/ping")
  @app.route("/ping/")
  def ping():
    return "PONG!", 200

  @app.route("/echo", methods=["GET", "POST"])
  @app.route("/echo/<path:path>", methods=["GET", "POST"])
  def echo(path=None):
    kubernetes_info = [
      "Kubernetes Info: ",
      "\tCluster Name: " + os.environ.get("CLUSTER_NAME", "N/A"),
      "\tNamespace: " + os.environ.get("POD_NAMESPACE", "N/A"),
      "\tNode Name: " + os.environ.get("NODE_NAME", "N/A"),
      "\tPod Name: " + os.environ.get("POD_NAME", "N/A"),
      "\tPod IP: " + os.environ.get("POD_IP", "N/A"),
      "\n"
    ]

    req = request.data
    # if request content-type is application/json get the json data
    if request.content_type == "application/json":
      req = request.get_json()

    request_info = [
      "Request Info: ",
      "\tMethod: " + request.method,
      "\tPath: " + request.path,
      "\tClient IP: " + request.remote_addr,
      "\n"

    ]

    request_headers = [
      "Request Headers: ",
    ]
    for key, value in request.headers:
      request_headers.append(f"\t{key}: {value}")
    request_headers.append("\n")

    request_body = [
      "Request Body: ",
      f"\t{req}",
      "\n"
    ]

    response = "\n".join(kubernetes_info + request_info + request_headers + request_body)
    return response, 200

  return app

def main():

  app = TransLogger(create_app(), setup_console_handler=True)
  serve(app, host = "0.0.0.0", port = PORT)

if __name__ == "__main__":
  main()
