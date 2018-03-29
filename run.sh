#!/usr/bin/env bash

redis-server &

cd NadekoBot/src/NadekoBot
dotnet run --configuration Release
