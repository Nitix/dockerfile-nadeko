#!/usr/bin/env bash

redis-server --daemonize yes

cd NadekoBot/src/NadekoBot
dotnet run --configuration Release
