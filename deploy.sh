#!/bin/bash

zip -9 -r atritus.love . -x *.git*
love atritus.love
