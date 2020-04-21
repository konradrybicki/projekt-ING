Hej :)

z tej strony Konrad, chciałbym przedstawić Wam obecny stan projektu.

Zanim przejdę do meritum, chcę tylko wyjaśnić kwestię dat w repo - maila z odnośnikami dostaliście zapewne we wtorek ok. godz. 18:00/19:00, natomiast repo wygląda jakby było przygotowane po wysłaniu - środa w nocy. Nic z tych rzeczy, kilka poprawek kosmetycznych w commitach, przez co musiałem dodać je jeszcze raz :)

Wracając do projektu..

Na ten moment aplikacja składa się jedynie z typowo backend’owej funkcjonalności. Z racji na to, że ciągle uczę się pracy z platformą Storyboards, nie zabrałem się jeszcze za interfejs. Udało mi się natomiast zaimplementować to, czego najbardziej się obawiałem, czyli mechanizm pobierający dane z API oraz dekodujący JSON’a do postaci rozpoznawanej przez Swifta - struct’ów.

W pliku NetworkingManager.swift znajduje się główny moduł mojej pracy, tam też dodałem kilka notatek, by przedstawić jej schemat (część z nich jest dla mnie - w celach typowo naukowych).

Nad projektem pracuję w tej chwili regularnie i staram się jak najszybciej “przebić się” z nauką Swifta do momentu, w którym będę w stanie popracować nad UI. Niestety, konfiguracja Xcode i pochodnych na VMPlayerze dość mocno spowolniła cały proces, ale już jest ok, i mogę w miarę komfortowo pracować nad zadaniem.

To chyba tyle na teraz, kolejne zmiany będą widoczne w commit’ach :)

PS: Screeny oraz ew. nagrania także będą pojawiać się w repo, głównie przy UI. Dziś wrzuciłem kompilację z dekodowania.

Pozdrawiam,
Konrad