/* Copyright 2016 
* 
* Diego Islas Ocampo
* Luis Fernando Saavedra
*
* This file is part of Dispatcher.
*
* Dispatcher is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* Dispatcher is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Dispatcher. If not, see http://www.gnu.org/licenses/.
*/

class Process {

    public int execution_time;
    public int arrival_time;
    public int times_blocked;
    public int blocked_time;
    public string id;
    public int turn;

    public Process (string id, int execution_time, int arrival_time, int times_blocked, int turn) {
        this.id = id;
        this.execution_time = execution_time;
        this.arrival_time = arrival_time;
        this.times_blocked = times_blocked;
        this.blocked_time = times_blocked * Dispatcher.block_time;
        this.turn = turn;
    }
}
