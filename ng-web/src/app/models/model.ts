export class Dispatcher{

    static block_time: number;
    static change_time: number;
    static quantum: number;
    processors: Array<Processor> = [];
    processes: Array<Process> = [];

    constructor(p: number, quantum: number, block_time: number, change_time: number) {
        Dispatcher.block_time = block_time;
        Dispatcher.change_time = change_time;
        Dispatcher.quantum = quantum;

        for (var i = 0; i < p; i++) {
            this.processors.push(new Processor(i));
        }
    }


    add_process(id: string, execution_time: number, arrival_time: number, times_blocked: number): void{
        this.processes.push(new Process(id, execution_time, arrival_time, times_blocked, this.processes.length ));
    }

    private get_best (arrival_time: number): Processor{
        let best_processor: Processor = this.processors[0];

        for(let processor of this.processors){
            if (processor.current_time < best_processor.current_time  && processor.current_time >= arrival_time) {
                best_processor = processor;

            } else if (processor.current_time <= best_processor.current_time && processor.current_time < arrival_time) {
               best_processor = processor;
               break;
           }
        }
        return best_processor;
    }

    dispatch(): void{
        for (let process of this.processes) {
            let best: Processor = this.get_best(process.arrival_time);
            best.execute(process);

            // console.log("Sent Process %s to Processor %d -> %f\n ", process.id, best.id, best.current_time);
        }
    }
}

export class Entry {
    tcc: number;
    te: number;
    tvc: number;
    tb: number;
    tt: number;
    ti: number;
    tf: number;
    process: Process;

    constructor(process: Process = null, tvc: number, tcc: number, ti: number) {
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

export class Process {

    public execution_time: number;
    public arrival_time: number;
    times_blocked: number;
    public blocked_time: number;
    id: string;
    turn: number;

    constructor(id: string, execution_time: number, arrival_time: number, times_blocked: number, turn: number) {
        this.id = id;
        this.execution_time = execution_time;
        this.arrival_time = arrival_time;
        this.times_blocked = times_blocked;
        this.blocked_time = times_blocked * Dispatcher.block_time;
        this.turn = turn;
    }
}

export class Processor{

    id: number;
    current_time: number;
    entries: Array<Entry> = [];

    constructor(id: number) {
        this.id = id;
        this.current_time = 0;
    }

    execute(process: Process) {
        let tcc: number = 0;
        let tvc: number = 0;

        if (process.arrival_time > this.current_time || this.entries.length == 0){
            this.current_time = process.arrival_time;
            this.entries.push(new Entry (null, tvc, tcc, this.current_time));
        } else{
            tcc = Dispatcher.change_time;
        }

        if ((process.execution_time % Dispatcher.quantum) == 0) {
            tvc = ((process.execution_time / Dispatcher.quantum)-1) * tcc;
        } else {
            tvc = (Math.trunc(process.execution_time / Dispatcher.quantum)) * tcc;
        }

        this.entries.push(new Entry (process, tvc, tcc, this.current_time));

        this.current_time += tcc;
        this.current_time += tvc;
        this.current_time += process.blocked_time;
        this.current_time += process.execution_time;
    }
}
