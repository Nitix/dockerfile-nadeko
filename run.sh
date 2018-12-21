#!/usr/bin/env bash

redis-server --daemonize yes

cd nadekobot/src/NadekoBot
dotnet run --configuration Release
