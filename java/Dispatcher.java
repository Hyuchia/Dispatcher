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

import java.util.*;

class Dispatcher {

    public static int block_time;
    public static int change_time;
    public static int quantum;
    public ArrayList<Processor> processors;
    public ArrayList<Process> processes;

    public Dispatcher (int processors, int quantum, int block_time, int change_time) {
        Dispatcher.block_time = block_time;
        Dispatcher.change_time = change_time;
        Dispatcher.quantum = quantum;
        this.processors = new ArrayList<Processor>();
        this.processes = new ArrayList<Process>();

        for (int i = 0; i < processors; i++) {
            this.processors.add (new Processor (i));
        }
    }

    public void add_process (String id, int execution_time, int times_blocked, int arrival_time) {
        this.processes.add (new Process(id, execution_time, arrival_time, times_blocked, this.processes.size ()));
    }

    private void sort(){
        for (int i = 0; i < this.processes.size(); i++) {
            for (int j = 1; j < (this.processes.size() - i); j++) {
                if (this.processes.get(j - 1).compareTo(this.processes.get(j)) > 0) {
                    Process temp = this.processes.get(j - 1);
                    this.processes.set(j - 1, this.processes.get(j));
                    this.processes.set(j, temp);
                }

            }
        }
    }

    private Processor get_best (int arrival_time) {
        Processor best_processor = this.processors.get (0);
        for(Processor processor : this.processors) {
            if (processor.current_time < best_processor.current_time  && processor.current_time >= arrival_time) {
                best_processor = processor;
            } else if (processor.current_time <= best_processor.current_time && processor.current_time < arrival_time) {
               best_processor = processor;
               break;
           }
        }
        return best_processor;
    }

    public void dispatch () {
        this.sort();
        for(Process process : this.processes) {
            Processor best = get_best (process.arrival_time);
            best.execute (process);
            System.out.println ("Sent Process "+ process.id + " to Processor " + best.id + " -> " + best.current_time);
        }
    }

    public static void main(String[] args){
        Dispatcher dispatcher = new Dispatcher(2, 3000, 15, 15);
        dispatcher.add_process("B", 300, 2, 0);
        dispatcher.add_process("D", 100, 2, 0);
        dispatcher.add_process("F", 500, 3, 0);
        dispatcher.add_process("H", 700, 4, 0);
        dispatcher.add_process("J", 300, 2, 1500);
        dispatcher.add_process("L", 3000, 5, 1500);
        dispatcher.add_process("N", 50, 2, 1500);
        dispatcher.add_process("O", 600, 3, 1500);
        dispatcher.add_process("A", 400, 2, 3000);
        dispatcher.add_process("C", 50, 2, 3000);
        dispatcher.add_process("E", 1000, 5, 3000);
        dispatcher.add_process("G", 10, 2, 3000);
        dispatcher.add_process("I", 450, 3, 3000);
        dispatcher.add_process("K", 100, 2, 4000);
        dispatcher.add_process("M", 80, 2, 4000);
        dispatcher.add_process("P", 800, 4, 4000);
        dispatcher.add_process("NN", 500, 3, 8000);

        dispatcher.dispatch();
    }
}
