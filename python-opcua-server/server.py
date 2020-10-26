#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Module to create an OPC UA server. Reference code:
https://github.com/FreeOpcUa/python-opcua/tree/master/examples
"""
import sys
sys.path.insert(0, "..")
import threading
import argparse
import time
import logging
import logging.config
import yaml
import coloredlogs
from pdb import set_trace
from opcua import ua, Server

__author__ = "Brent Maranzano"
__license__ = "MIT"


class OPCServer(object):
    """Create an OPC UA server.
    """
    def __init__(self):
        self._server = None
        self._myvar = None
        self._setup_logger()
#        self._thread_lock = threading.Lock()
#        self._update_thread = threading.Thread(target=self._update_data, daemon=True)

    def _setup_logger(self, config_file="./logger_conf.yml"):
        """Start the logger using the provided configuration file.
        """
        try:
            with open(config_file, 'rt') as file_obj:
                config = yaml.safe_load(file_obj.read())
                logging.config.dictConfig(config)
                coloredlogs.install()
        except Exception as e:
            print(e)
        logging.basicConfig(level=logging.INFO)
        coloredlogs.install(level=logging.INFO)
        self._logger = logging.getLogger("opclogger")
        self._logger.debug("opc_server logger setup")

    def _instantiate_server(self,
            endpoint="opc.tcp://0.0.0.0:4840/freeopcua/server/"):
        """Instatiate the Server class with the provided endpoint.

        Arguments
        endpoint (str): URL of the OPC endpoint

        Returns opcua server
        """
        server = Server()
        server.set_endpoint("opc.tcp://0.0.0.0:4840/freeopcua/server/")
        self._logger.debug("OPC UA server instantiated: {}".format(endpoint))
        return server

    def _create_namespace(self, uri="http://examples.freeopcua.github.io"):
        """Create some namespace.

        Arguments
        uri (str): URI for opc ua server tag
        """
        uri = uri
        idx = self._server.register_namespace(uri)

        objects = self._server.get_objects_node()

        myobj = objects.add_object(idx, "MyObject")
        myvar = myobj.add_variable(idx, "MyVariable", 6.7)

        myvar.set_writable()

        self._logger.info("Created URI, tag and set variable")

        return myvar

    def _start_server(self):
        """Start the server.
        """
        self._server.start()
        self._logger.info("OPC UA server started")

    def _update_data(self):
        """Update the OPC server data.
        """
        self._logger.info("starting _update_data")
        try:
            count = 0
            while True:
                time.sleep(1)
                count += 0.1
                self._myvar.set_value(count)
                self._logger.debug("updated myvar")
        finally:
            self._close_server()

    def _close_server(self):
        """Close the server.
        """
        self._server.stop()
        self._logger.info("OPC UA server stopped")

    def run(self):
        """Run the server.
        """
        self._server = self._instantiate_server()
        self._myvar = self._create_namespace()
        self._start_server()
        self._update_data()


if __name__ == "__main__":
    server = OPCServer()
    server.run()
