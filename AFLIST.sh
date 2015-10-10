#!/usr/bin/perl

use strict;
use warnings;
use Switch;

my $input = '';

while ($input ne '6')
{
    clear_screen();

    print "1. -h (ayuda)\n".
          "2. -r\n". 
          "3. -s\n". 
          "4. -r-w\n". 
          "5. -s-w\n".
          "6. salir\n";

    print "Seleccione una opcion: ";
    $input = <STDIN>;
    chomp($input);

    switch ($input)
    {
      
      case '1'
        {
            $input = '';
            clear_screen();
            print "AYUDA\n";
        }        

  
      case '2'
        {
            $input = '';

            while ($input ne '7')
            {
                clear_screen();

                print "1. Filtro por central\n".
                      "2. Filtro por agente\n".
                      "3. Filtro por umbral\n".
                      "4. Filtro por tipo de llamada\n".
                      "5. Filtro por tiempo de conversacion\n".
                      "6. Filtro por numero A\n".
                      "7. Volver al menu principal\n";

                print "Seleccione una opcion: ";
                $input = <STDIN>;
                chomp($input);
            }

            $input = '';
        }

      case '3'
        {
            $input = '';
            clear_screen();
            print "Estadisticas\n";
        } 

    }
}

exit(0);

sub clear_screen
{
    system("clear");
}