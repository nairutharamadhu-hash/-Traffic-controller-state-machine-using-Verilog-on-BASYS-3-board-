library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity traffic_controller is
    Port (
        reset : in STD_LOGIC;                -- Button input
        clk_100MHz : in STD_LOGIC;           -- 100 MHz clock input
        main_st : out STD_LOGIC_VECTOR(2 downto 0); -- Main street LEDs
        cross_st : out STD_LOGIC_VECTOR(2 downto 0) -- Cross street LEDs
    );
end traffic_controller;

architecture Behavioral of traffic_controller is

    -- Internal signals
    signal w_1Hz : STD_LOGIC;
    signal w_reset : STD_LOGIC;

    -- Component declarations
    component state_machine
        Port (
            reset : in STD_LOGIC;
            clk_1Hz : in STD_LOGIC;
            main_st : out STD_LOGIC_VECTOR(2 downto 0);
            cross_st : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component oneHz_gen
        Port (
            clk_100MHz : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_1Hz : out STD_LOGIC
        );
    end component;

    component sw_debounce
        Port (
            clk : in STD_LOGIC;
            btn_in : in STD_LOGIC;
            btn_out : out STD_LOGIC
        );
    end component;

begin

    -- Instantiate state machine
    SM_inst : state_machine
        Port map (
            reset => w_reset,
            clk_1Hz => w_1Hz,
            main_st => main_st,
            cross_st => cross_st
        );

    -- Instantiate 1Hz clock generator
    UNO_inst : oneHz_gen
        Port map (
            clk_100MHz => clk_100MHz,
            reset => w_reset,
            clk_1Hz => w_1Hz
        );

    -- Instantiate debounce module
    DB_inst : sw_debounce
        Port map (
            clk => clk_100MHz,
            btn_in => reset,
            btn_out => w_reset
        );

end Behavioral;