new Network();

// TODO: Async operations, WebSocket, raw, broadcast, error handling, and more robust network management.
// TODO: Currently, this is a basic connection and data transfer implementation. Cannot receive data yet.

/**
 * Network class for handling network operations.
 * @returns {Struct.Network}
 */
function Network() constructor {
    /**
     * This function is used to create a new server.
     * @returns {Struct.Server}
     * @param {Constant.SocketType} type - The type of server to create. Use network_socket_tcp or network_socket_udp.
     * @param {Real} port - The port to listen on.
     * @param {Real} max_client - The maximum number of clients that can connect to the server.
     */
    static create_server = function(_type, _port, _max_client) {
        var _server = new Server();
        _server.socket = network_create_server(_type, _port, _max_client);
        if (_server.socket < 0) {
            delete _server;
            throw new Error("Failed to create server: " + string(_server.socket));
        }
        _server.type = _type;
        _server.port = _port;
        return _server;
    }

    /**
     * This function is used to create a new client.
     * @returns {Struct.Client}
     * @param {Constant.SocketType} type - The type of client to create. Use network_socket_tcp or network_socket_udp.
     */
    static create_client = function(_type) {
        var _client = new Client();
        _client.socket = network_create_socket(_type);
        if (_client.socket < 0) {
            delete _client;
            throw new Error("Failed to create client: " + string(_client.socket));
        }
        _client.type = _type;
        return _client;
    }

    /**
     * This function will return the IP address of the given URL.
     * @returns {String}
     * @param {String} url - The URL to get the IP of (a string).
     */
    static resolve = function(_url) {
        return network_resolve(_url);
    }

    /**
     * With this function you can set different network configurations.
     * @returns {String}
     * @param {Constant.NetworkConfig} config - The config constant to set. Check the manual for available configurations.
     * @param {Any} setting - The setting value of the config.
     */
    static set_config = function(_config, _setting) {
        return network_set_config(_config, _setting);
    }
}

/**
 * Server class for handling server operations.
 * @returns {Struct.Server}
 */
function Server() constructor {
    socket = -1;
    type = -1;
    port = -1;
    address = "";

    /**
     * This function removes the socket.
     * @returns {Undefined}
     */
    static destroy = function() {
        network_destroy(self.socket);
        self.socket = -1;
    }

    /**
     * This function sets the timeout for reading and writing operations. Note that the timeout does not generate any type of event.
     * @returns {Undefined}
     * @param {Real} read - The timeout for reading operations in milliseconds.
     * @param {Real} write - The timeout for writing operations in milliseconds.
     */
    static set_timeout = function(_read, _write) {
        network_set_timeout(self.socket, _read, _write);
    }

    /**
     * This function sends a buffer to the connected client or server.
     * @returns {Real}
     * @param {Id.Buffer} buffer - The buffer to send.
     * @param {Real} size - The size of the buffer to send.
     */
    static send_buffer = function(_buffer, _size) {
        var _sent = -1;

        if (self.type == network_socket_tcp) {
            _sent = network_send_packet(self.socket, _buffer, _size);
        } else if (self.type == network_socket_udp) {
            _sent = network_send_udp(self.socket, self.address, self.port, _buffer, _size);
        }

        if (_sent < 0) {
            throw new Error("Failed to send data: " + string(_sent));
        }
        // TODO: Should I handle this mismatch?
        if (_sent != _size + 12) {
            throw new Error("Sent size does not match expected size: " + string(_sent) + " != " + string(_size + 12));
        }

        return _sent;
    }

    /**
     * This function sends a string to the connected client or server.
     * @returns {Real}
     * @param {String} str - The string to send.
     */
    static send_string = function(_str) {
        var _buffer = buffer_create(string_length(_str) + 13, buffer_fixed, 1);
        buffer_write(_buffer, buffer_string, _str);
        var _sent = self.send_buffer(_buffer, buffer_get_size(_buffer));
        buffer_delete(_buffer);
        return _sent;
    }
}

/**
 * Client class for handling client operations.
 * @returns {Struct.Client}
 */
function Client() : Server() constructor {
    /**
     * This function sends a request to connect to a server.
     * @returns {Real|Id.Socket}
     * @param {String} address - The address of the server to connect to.
     * @param {Real} port - The port of the server to connect to.
     */
    static connect = function(_address, _port) {
        if (self.type == network_socket_tcp) {
            var _result = network_connect(self.socket, _address, _port);
            if (_result < 0) {
                throw new Error("Failed to connect to server: " + string(_result));
            }
            self.address = _address;
            self.port = _port;
            // TODO: Handle the result properly.
            // return _result;
        } else if (self.type == network_socket_udp) {
            self.address = _address;
            self.port = _port;
        }
    }
}
