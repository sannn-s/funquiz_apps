# Fun Quiz Apps

## A. Aplikasi ini bertema pendidikan, yang dimana aplikasi ini bertujuan untuk menambah wawasan orang-orang tentang berbagai macam ilmu pengetahuan lewat aplikasi quiz sederhana yang lebih bersifat seperti flashcard seperti ini.
Aplikasi ini memiliki 4 halaman, setiap halaman nya memiliki tujuan yang berbeda-beda:
1. Halaman login, halaman ini berfungsi sebagai pintu masuk user ke dalam aplikasi artinya ini merupakan halaman untuk mencatat data login dari user. Data login yang diperlukan yaitu email dan juga password. Pada aplikasi ini dapat login tetapi masih bersifat statis jadi belum ada database untuk menyimpan login artinya dapat menggunakan email apapun dan password apapun asalkan memenuhi ketentuan.
2. Halaman utama, halaman utama ini berfungsi untuk menampilkan jenis kategori dari quiz yang ada. Jadi bisa memilih ingin memulai quiz dengan kategori yang mana, selain itu terdapat juga bagian yang menampilkan tumbol untuk random quiz, yang dimana ini akan menavigasi ke arah bagian random quiz atau quiz acak dan ada fitur "search" untuk mencari kategori dari quiz yang ingin dicari.
3. Halaman Quiz, pada halaman ini berfungsi untuk menampilkan pertanyaan dan juga jawaban dari setiap soal, di dalam halaman ini terdapat sebuah card yang menampilkan pertanyaan dan jawaban quiz. Pertanyaan quiz akan muncul terlebih dahulu, jika card ditekan maka card akan berbalik dan menampilkan jawaban dari pertanyaan tersebut. Selain itu, di halaman ini terdapat 2 tombol yaitu tombol "next" dan juga tombol "previous" yang berfungsi untuk melanjutkan ke soal berikutnya atau kembali ke soal sebelumnya dan terakhir di halaman ini terdapat icon "love" yang berfungsi untuk "menyukai" soal-soal yang yang disukai.
4. Halaman profile, pada halaman ini berfungsi untuk menampilkan profil dari pengguna atau user, disini juga terdapat ket berapa soal yang "disukai" kemudian terdapat keterangan sudah berapa soal yang dibuka atau dimainkan, kemudian terdapat fitur setting yang di dalamnya terdapat fungsi untuk menghapus semua kartu yang sudah dilihat, ada fitur untuk melihat dan menghapus semua kartu yang disukai dan terdapat beberapa tambahan penjelasan lainnya dan yang terakhir terdapat button "logout" yang berfungsi untuk keluar.

## B. Daftar Endpoint API:
Aplikasi ini menggunakan Firebase Realtime Database yang diakses melalui protokol HTTP (REST API) dengan menambahkan ekstensi .json.
1. Base URL
   [https://funquiz-123-default-rtdb.firebaseio.com/](https://funquiz-123-default-rtdb.firebaseio.com/)
2. Endpoint: Mengambil Semua Soal (Fetch Data)
   Endpoint ini digunakan untuk mengambil seluruh database soal (Sports, History, dll) dalam satu kali request.
   - Method: GET

## C. Cara Instalasi
1. Prasyarat Sistem
   - Flutter SDK (versi stabil terbaru)
   - Android Studio (dengan plugin Flutter) atau Visual Studio Code (dengan ekstensi Flutter)
   - Koneksi internet (Wajib untuk fetch API)
   - Emulator Android/iOS atau smartphone untuk menjalankan aplikasi
2. Langkah Instalasi
   - Download folder FunQuizApps

## D. Adapun langkah-langkah untuk menjalankan aplikasi yaitu:
1. Pada halaman login, user melakukan login terlebih dahulu menggunakan email dan juga password, untuk sekarang masih dalam tahap pengembangan jadi login nya belum tersimpan di database jadi bersifat statis artinya dapat menggunakan email apapun dan password apapun asalkan memenuhi ketentuan
2. Kemudian di halaman berikutnya, user dapat memilih ingin memulai quiz dengan pilihan random quiz atau quiz sesuai kategori
3. Jika sudah menentukan, user akan masuk ke halaman quiz yang dimana terdapat soal dan juga jawaban. Setelah user melihat soal dan jika sudah menebak jawaban atau belum terpikirkan jawaban nya apa user dapat menekan card pertanyaan tersebut dan card tersebut akan berbalik kemudian user dapat melihat jawaban nya
4. Setelah itu user dapat meng klik button "next" untuk melanjutkan ke soal berikutnya dan jika ingin "menyukai" soal tersebut user dapat menekan icon "love"
5. Jika user menekan "next" maka akan lanjut ke soal berikutnya dan sama seperti langkah sebelumnya, jika ingin melihat soal dapat menekan card pertanyaan tersebut dan jika ingin kembali ke soal sebelumnya dapat menekan "previous"
6. Langkah sebelumnya dapat disesuaikan, jika soal sudah sampai ke soal 10 user dapat kembali dengan mengklik tombol kembali di pojok kiri atas dan itu akan mengarahkan ke arah halaman utama
7. Sesudah itu user dapat memilih kategori quiz yang lain, jika user ingin keluar dapat menekan tombol logout yang ada di halaman profile dengan cara mengklik icon profile di halaman utama dan nanti akan diarahkan ke halaman profile dan jika sudah di halaman itu dapat menekan tombol logout untuk keluar dari aplikasi
