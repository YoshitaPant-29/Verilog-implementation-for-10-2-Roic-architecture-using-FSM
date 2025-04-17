`timescale 1ns / 1ps

module row_col_traversal (
    input clk,
    input rst,
    output reg [8:0] col_enable,   // 9 bits for 10 columns
    output reg [1:0] row_enable    // 2 bits for 2 rows
);

    // FSM state encoding
    parameter IDLE        = 3'd0;
    parameter ROW_SELECT  = 3'd1;
    parameter COLUMN_HOLD = 3'd2;
    parameter INTER_DELAY = 3'd3;
    parameter NEXT_ROW    = 3'd4;
    parameter DONE        = 3'd5;

    reg [2:0] state, next_state;

    // Counters
    reg [1:0] row_count;    // for 2 rows
    reg [3:0] col_count;    // for 10 columns
    reg [6:0] hold_counter; // delay counter for #70
    reg [3:0] delay_counter; // delay counter for #10

    // FSM state transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            row_count <= 0;
            col_count <= 0;
            hold_counter <= 0;
            delay_counter <= 0;
            row_enable <= 0;
            col_enable <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    row_enable <= 0;
                    col_enable <= 0;
                end

                ROW_SELECT: begin
                    row_enable <= (1 << row_count);
                    col_enable <= (1 << col_count);
                    hold_counter <= 0;
                end

                COLUMN_HOLD: begin
                    if (hold_counter < 70)
                        hold_counter <= hold_counter + 1;
                    else
                        delay_counter <= 0;
                end

                INTER_DELAY: begin
                    if (delay_counter < 10)
                        delay_counter <= delay_counter + 1;
                    else begin
                        if (col_count < 9) begin
                            col_count <= col_count + 1;
                            col_enable <= (1 << (col_count + 1));
                            hold_counter <= 0;
                        end
                    end
                end

                NEXT_ROW: begin
                    if (row_count < 1) begin
                        row_count <= row_count + 1;
                        col_count <= 0;
                        row_enable <= (1 << (row_count + 1));
                        col_enable <= 1;
                        hold_counter <= 0;
                    end else begin
                        row_enable <= 0;
                        col_enable <= 0;
                    end
                end

                DONE: begin
                    row_enable <= 0;
                    col_enable <= 0;
                end
            endcase
        end
    end

    // FSM next-state logic
    always @(*) begin
        case (state)
            IDLE:          next_state = ROW_SELECT;
            ROW_SELECT:    next_state = COLUMN_HOLD;
            COLUMN_HOLD:   next_state = (hold_counter >= 70) ? INTER_DELAY : COLUMN_HOLD;
            INTER_DELAY:   next_state = (delay_counter >= 10) ? ((col_count < 9) ? COLUMN_HOLD : NEXT_ROW) : INTER_DELAY;
            NEXT_ROW:      next_state = (row_count < 1) ? COLUMN_HOLD : DONE;
            DONE:          next_state = DONE;
            default:       next_state = IDLE;
        endcase
    end

endmodule
