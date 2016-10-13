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

class Dispatcher {

    public static int block_time;
    public static int change_time;
    public static int quantum;
    public List<Processor> processors;
    public List<Process> processes;

    public static CompareFunc<Process> timecmp = (a, b) => {
        return ((int) (a.arrival_time > b.arrival_time ) - (int) (a.arrival_time < b.arrival_time)) + ((int) (a.turn > b.turn ) - (int) (a.turn < b.turn));
    };

    public Dispatcher (int processors, int quantum, int block_time, int change_time) {
        Dispatcher.block_time = block_time;
        Dispatcher.change_time = change_time;
        Dispatcher.quantum = quantum;

        for (int i = 0; i < processors; i++) {
            this.processors.append (new Processor (i));
        }
    }

    public void add_process (string id, int execution_time, int times_blocked, int arrival_time) {
        this.processes.insert_sorted (new Process(id, execution_time, arrival_time, times_blocked, (int) this.processes.length ()), timecmp);
    }

    private Processor get_best (int arrival_time) {
        Processor best_processor = (this.processors.first ()).data;
        foreach (Processor processor in this.processors) {
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
        foreach (Process process in this.processes) {
            Processor best = get_best (process.arrival_time);
            best.execute (process);
            stdout.printf ("Sent Process %s to Processor %d -> %d\n ", process.id, best.id, best.current_time);
        }
    }

    /*public static void main (string[] args) {
        Dispatcher dispatcher = new Dispatcher (2, 10, 0);

        dispatcher.add_process ("A", 400, 3000, 2);
        dispatcher.add_process ("B", 300, 0, 2);
        dispatcher.add_process ("C", 50, 3000, 2);
        dispatcher.add_process ("D", 100, 0, 2);
        dispatcher.add_process ("E", 1000, 3000, 5);
        dispatcher.add_process ("F", 500, 0, 3);
        dispatcher.add_process ("G", 10, 3000, 2);
        dispatcher.add_process ("H", 700, 0, 4);
        dispatcher.add_process ("I", 450, 3000, 3);
        dispatcher.add_process ("J", 300, 1500, 2);
        dispatcher.add_process ("K", 100, 4000, 2);
        dispatcher.add_process ("L", 3000, 1500, 5);
        dispatcher.add_process ("M", 80, 4000, 2);
        dispatcher.add_process ("N", 50, 1500, 2);
        dispatcher.add_process ("Ñ", 500, 8000, 3);
        dispatcher.add_process ("O", 600, 1500, 3);
        dispatcher.add_process ("P", 600, 4000, 3);

        dispatcher.dispatch ();
    }*/
}
