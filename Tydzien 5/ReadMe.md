####Wynik próby:
VMki w Hyper-V nie udało się utworzyć.

Sprawdziłem jeszcze dwa scenariusze:
1. Analogiczny test z próbą utworzenia VMki w Hyper-V na podstawie niezaszyfrowanego dysku - tym razem wszystko się udało.
2. Postawienie drugiej VMki poprzez Azure Portal na podstawie tego zaszyfrowanego dysku:
  - Zacząłem od zrobienia snapshota zaszyfrowanego dysku.
  - Następnie zrobiłem nowy managed dysk z tego snaphsota.
  - Na koniec z sukcesem utworzyłem nową VMkę z tego dysku.
