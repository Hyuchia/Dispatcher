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

class Entry {
    public int tcc;
    public int te;
    public int tvc;
    public int tb;
    public int tt;
    public int ti;
    public int tf;
    public Process? process;

    public Entry (Process? process, int tvc, int tcc, int ti) {
        if (process != null) {
            this.process = process;
            this.te = process.execution_time;
            this.tb = process.blocked_time;
            this.tvc = tvc;
            this.tcc = tcc;
            this.ti = ti;
            this.tt = this.te + this.tb + this.tvc + this.tcc;
            this.tf = ti + this.tt;
        }
    }

}
