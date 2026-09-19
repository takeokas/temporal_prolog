Temporal Prolog(たけおか版)マニュアル

たけおか (竹岡尚三)

# 0. 本Temporal Prolog について  
   
Temporal Prologは、桜川貴司氏が考案した、時相論理型言語である。  
本Temporal Prologは、竹岡が作成した、その実行系の実装の一つである。  
本Temporal Prologは、時相論理型言語処理系の実現として、重要ないくつかの特徴を持つ。 それは、別文書に詳述する。  
  
  
# 1. 本Temporal Prologの概略文法  
* Temporal Prologでは、時相記号の付かない節は、Pure Prologとまったく同じである。  
* 時間に関する記号は●(一つ過去を表す時相記号)しかない。  
●はファンクタのシンボルの先頭につける。  
●の付いた項はボディ部にしか現れない。  
(その他の時相記号は、手による変換をして頂きたい :-P)  
* 本Temporal Prologは、上の節から順に試行する。(通常のPrologと同じ)  
ボディ部のファンクタに時相記号●付きの項があった場合、一つ前の時刻(過去)で成立しアサートされた事実を参照に行く。  
その他は、通常のPrologとまったく同じである。  
* GCL(KCL)では、"●"の代わりに、"@"を使用する。GCLは、文字を1Byte単位でしか扱えないため。  
その他、マルチバイト文字をうまく扱えないLisp処理系での実行は、ソースコードの#+kcl のあたりを参照して頂きたい。  
* Prolog変数は、*から始まるLispシンボル  
* リストは、Lispのリストである。リストの car, cdr を分ける記号は"."。  
* 節は、ヘッドとそれに続くボディ部の各項を一つのリストにする。  
ヘッドは、ファンクタと引数をリストにする。  
各項も、ファンクタと引数を、それぞれの項ごとに1つのリストにする。  
例えば、prologのappendは、以下のように書く  
```
    ((append () *x *x))  
    ((append (*a . *x) *y (*a . *z)) (append *x *y *z))))  
```   

# 2. Temporal Prolog の制御
本Temporal Prolog の実行などを制御する関数などを下に揚げる。  


## (tmpro)
本Temporal Prologの実行を開始する。  
Lisp関数であり、Lispの top level から呼び出す。  
実行開始時に、節の間の過去参照の依存関係を見て、自動的に実行すべき節 を決める。そして、それらの節を自動的に、毎時刻 実行する。  
ある時刻にやるべきことが終了(一仕切り 1-shikiri)したら、 その結果を表示し、時刻を1進め、また、その時刻にやるべきことを行う。 それを繰り返す。  

表示の例
```
**** 1-shikiri **** *time*=3
*hito-mukashi*=(((●P (0 0 0))) ((●Q 6)))
```

一つの時刻である「一仕切り」のリダクションが終了すると、上のような表示が出力される。  
\*hito-mukashi\* は、時間の依存関係に基づいてリダクションされ、 次の時刻で参照されるべき、一世代過去の事実のデータベースである。  
\*hito-mukashi\*に、実行結果が入っていると解釈することもできる。 (使用者は、必ずしも、リダクションの最終結果だけを求めているわけでは無いだろうが)  

Temporal Prologの実行が停止するのは、(set-halt-time 時刻)で設定された時刻になった時である。  
(停止時刻のデフォールトは、10)  
Temproral Prologは、対話的には動かない。  


## (tmpro-assert-new facts)
これまでの事実をクリアして、 事実データベース facts をアサートする。  
Lisp関数。  

## (tmpro-assert facts)
事実データベース facts をアサートする。  
これまでの事実は、クリアしない。  
Lisp関数。  

## (tmpro-assert-at0-new facts)
時刻 0 時だけ真である事実データベース facts をアサートする。  
時刻 0 は、「at0」 と呼ばれる。  
これまでに登録済みの at0 事実は、クリアされる。  
ヘッド部に●の付いた事実も登録できる。それは、時刻0で、その直前の 過去として参照される。  
Lisp関数。  

## (tmpro-assert-at0 facts)
時刻 0 時だけ真である事実データベース facts をアサートする。  
時刻 0 は、「at0」 と呼ばれる。  
ヘッド部に●の付いた事実も登録できる。それは、時刻0で、その直前の 過去として参照される。  
Lisp関数。  

## (set-halt-time 時刻)
停止する時刻を数値で設定する。デフォールト値は、10。  
Lisp関数。  

## (tmpro-trace t)
Temproal Prologの実行時に、トレース情報を表示するように指定する。  
Lisp関数。  

## (tmpro-trace nil)
Temproal Prologの実行時に、トレース情報を表示しないように、指定。  
Lisp関数。  

# 3. 組込み述語、関数など
Prolog中で使用できる組込み述語、組込み関数などを以下に掲げる。  
## ~ 節
Not。「~」記号直後の節のリダクション結果の真偽を反転する。  

## (+ *x *y *z)
数値加算 *z = *x + *y  

## (- *x *y *z)
数値減算 *z = *x - *y  

## (mul *x *y *z)
数値乗算 *z = *x * *y  

## (/ *x *y *z)
数値除算 *z = *x / *y  

## (< *x *y)
数値比較 *x < *y  

## (<= *x *y)
数値比較 *x <= *y  

## (=< *x *y)
数値比較 *x =< *y  

## (> *x *y)
数値比較 *x > *y  

## (>= *x *y)
数値比較 *x >= *y  

## (== *x *x)
比較 *x == *y  

## (at *x)
現在の時刻を *x に入れる。  

## (read *z)
端末から read して、*z に入れる。read中は、実行は停止。  

## (print *x)
端末へ print する。末尾で改行付き。  

## (prin1 *x)
端末へ print する。改行無し。  

## (terpri)
端末へ改行を出力。  

## (assert *x)
*x を事実データベース(節の集まり)として、事実データベースへ、追加アサート。  
Temproal Prologが実行すべき節のリストには影響しない。  
※retractの類は無い。本処理系は、あくまで、pure prologなのである。  

# 4. Prolog
本処理系は、pure Prologとしても使用できる。  
## (proa)
Prolog の対話 top level を起動する。  
プロンプトは、@?- 。
* プロンプトで、「end」を入力するとPrologを終了。
* プロンプトで、「trace」を入力すると、Prologの実行時に、トレース情報を表示する。
* プロンプトで、「notrace」を入力すると、Prologの実行時に、トレース情報を表示しない。
* シンボルを入力して、それが lisp変数としてバインド済みであれば、その内容を表示。
* 入力がlistであり、そのcarがlistでなければ、lisp S式としてLispで評価して、 結果を表示する。
* 入力が list で、そのcarも listであれば、それをゴール入力として、 Prologリダクションを始める。
* 
## Pure Prologからの拡張
* Not演算子「~」がある。直後の節のリデュース結果の真偽を反転する。
* ●がついた節を参照すると、lisp変数 \*hito-mukashi\* にセットされている 事実データベースを参照し、その中を探索する。
* - Temporal Prologの組込み述語、組込み関数を実行できる
    
## 5. 事実データベース、節の例
事実データベースは、複数の節を一つにリストにしたものである。  
節は、ヘッドと複数のボディを一つのリストにしたものである。  
節であるリストの先頭の項がヘッドで、それに続く項の列がボディである。  

節の例

```
 ((append (*a . *x) *y (*a . *z))  (append *x *y *z))
```
 
事実データベースの例
```
 (((append () *x *x))
  ((append (*a . *x) *y (*a . *z))   (append *x *y *z)) )
 ```

事実は、Lispのtop levelから、
```
(tmpro-assert-new
 '(
   ((append () *x *x))
   ((append (*a . *x) *y (*a . *z))   (append *x *y *z)) ))
 ```
として、データベースに登録することができる。 これは、すなわち一度に複数の節をアサートすることである。  
  
過去の事実を記憶するデータベースに登録するには、
(tmpro-assert-at0-new) を使用して、データベースに登録したのち、(tmpro) を起動すると、\*hito-mukashi\*にセットされる。が、これは実用的には利用し難い。  

実用的には、過去の事実を記憶するデータベースに直接登録する。
それは、\*hito-mukashi\*という変数に事実をセットすればよい。
そこに入れる節のヘッド部のファンクタには、「●」が付いていなければならない。 ●がなければ、永久に参照されることはない。


## 6. 文法
a) 変数  
Prologの変数は 「\*」から始まるシンボルである、  
例: *x は変数である。  

b) リスト  
Lispのlistが、そのままリストである。  
「.」が car と cdr を分ける記号である。  
例えば、 (*a . *x) と書くと、*aにリストの car が、*x にリストの cdr がマッチする。  


c) 過去の参照  
過去を示す記号は「●」である。  
(マルチバイト文字をうまく扱えない Gnu Common Lisp (Kyoto Common Lisp)などでは「@」を使用)。  
●は、ボディ部のファンクタにのみ付けることができる。  
●の付いた節がゴールとして与えられると、Temproral Prolog(pure Prolog)は 過去データベースを参照に行く。  



拡張BNF(AN)記法風 記述
```
<事実データベース> ::= (<節> [<節>...])

<節> ::= (<ヘッド> [<ボディ>])

<ヘッド> ::= (<ファンクタ> [<引数>...])
<ボディ> ::= (<ファンクタ> [<引数>...]) [<ボディ>...]

<引数> ::= <定数> | <変数>

<定数> とは、 Lispシンボル、数、Lispリスト
<変数> とは、 「*」から始まるLispシンボル
```

## 7. プログラム例
a) nobiru.lsp  
pのリストが伸びる。同時に、qの数が2づつ増加する。  
```
(tmpro-assert-new
 '(
   ((p *y) (●p *x)(append *x (0) *y))
   ((q *y) (●q *x)(+ *x 2 *y))
   ((append () *x *x))
   ((append (*a . *x) *y (*a . *z)) (append *x *y *z))))

(tmpro-assert-at0-new
 '(
   ((●p NIL))
   ((●q 0))))
```
 
b) not.lsp  
qは毎時刻" q "を印字しながら、そのリダクション結果は、一時刻ごとに真と偽が入れ替わる。  
pは、●qが偽であれば、" p "を印字しながら成功し、逆に、●qが真であれば、印字せず失敗する。  
rは、pをリダクション対象にするための依存関係を作るためだけの、捨て節である。  
```
(tmpro-assert-new
 '(
   ((p)  ~(●q) (print " p "))
   ((q) (print " q ") ~(●q))
   ((r) (●p))))
```
 
c) factorial.lsp  
階乗を行う。繰り返しは時間方向。1時刻ごとに、階乗の計算が進む。  
節zは、階乗の終了時にprintを行うための節。計算を行うだけなら、不要。  

```
(tmpro-assert-new
 '(
   ((f *n1 *ir1 *r) (●f *n *ir *r)(> *n 0)(- *n 1 *n1)(mul *ir *n *ir1))
   ((z) (●f 1 *r *x)(prin1 "fact=")(print *r))
   ((z) (●z)))

(tmpro-assert-at0-new 
 '(
   ((●f 4 1 *r))))
 ```

d) hanoi.lsp  
パズル「ハノイの塔」を解く、通常 Pure Prologプログラム。  
```
(tmpro-assert-new
 '(((hanoi 1 *f *t *v) (prin1 *f)(prin1 ->)(print *t))
   ((hanoi *n *f *t *v) (- *n 1 *n1)
    (hanoi *n1 *f *v *t)
    (hanoi 1 *f *t *v)
    (hanoi *n1 *v *t *f))))
```
 
## 9. 実行例
```
This is SBCL 1.0.40.0.debian, an implementation of ANSI Common Lisp.
More information about SBCL is available at .

SBCL is free software, provided as is, with absolutely no warranty.
It is mostly in the public domain; some portions are provided under
BSD-style licenses.  See the CREDITS and COPYING files in the
distribution for more information.
* (load "tmpro114.lsp")   ;;; 本処理系のロード

T
*
*

;;;;;;;;;;;; nobiru の例 ;;;;;;;;;;;;;;;
* (tmpro-assert-new
 '(
   ((p *y) (●p *x)(append *x (0) *y))
   ((q *y) (●q *x)(+ *x 2 *y))
   ((append () *x *x))
   ((append (*a . *x) *y (*a . *z)) (append *x *y *z))))


(((P *Y) (●P *X) (APPEND *X (0) *Y)) ((Q *Y) (●Q *X) (+ *X 2 *Y))
 ((APPEND NIL *X *X)) ((APPEND (*A . *X) *Y (*A . *Z)) (APPEND *X *Y *Z))
 ((+ *X *Y *Z) (*SYSTEM-FUNC* PRO+ *X *Y *Z))
 ((- *X *Y *Z) (*SYSTEM-FUNC* PRO- *X *Y *Z))
 ((MUL *X *Y *Z) (*SYSTEM-FUNC* PRO* *X *Y *Z))
 ((/ *X *Y *Z) (*SYSTEM-FUNC* PRO/ *X *Y *Z)) ((< *X *Y) (*SYSTEM* < '*X '*Y))
 ((<= *X *Y) (*SYSTEM* <= '*X '*Y)) ((=< *X *Y) (*SYSTEM* <= '*X '*Y))
 ((> *X *Y) (*SYSTEM* > '*X '*Y)) ((>= *X *Y) (*SYSTEM* >= '*X '*Y))
 ((== *X *X)) ((AT *X) (*SYSTEM* EQL *TIME* '*X))
 ((READ *Z) (*SYSTEM-FUNC* PRO_READ *Z))
 ((PRINT *X) (*SYSTEM* PROGN (FORMAT T "~s~%" '*X) T))
 ((PRIN1 *X) (*SYSTEM* PROGN (FORMAT T "~s" '*X) T))
 ((TERPRI) (*SYSTEM* PROGN (FORMAT T "~%") T))
 ((ASSERT *X) (*SYSTEM* SETQ *FACTS* (APPEND *FACTS* (CONS '*X NIL))))
 ((VI *FILE) (*SYSTEM* PROGN (ED '*FILE) (PRO_LOAD '*FILE) T))
 ((VI) (*SYSTEM* PROGN (ED 'BAR.PRO) (PRO_LOAD 'BAR.PRO) T))
 ((LOAD *FILE) (*SYSTEM* PROGN (PRO_LOAD '*FILE) T))
 ((SAVE *FILE) (*SYSTEM* PROGN (PRO_SAVE '*FILE) T)))
* (tmpro-assert-at0-new
'(
  ((●p NIL))
  ((●q 0))
  ))
 *at_000*=(((●P NIL)) ((●Q 0))) 
NIL
* (tmpro)
*ima-mukashi*=(((●Q 0)) ((●P NIL))) *at_0*=NIL
*yaraneba*=(((●Q *Y) (●Q *X) (+ *X 2 *Y)) ((●P *Y) (●P *X) (APPEND *X (0) *Y)))
**** 1-shikiri **** *time*=0
*hito-mukashi*=(((●Q 0)) ((●P NIL)))
*yaraneba*=(((●Q *Y) (●Q *X) (+ *X 2 *Y)) ((●P *Y) (●P *X) (APPEND *X (0) *Y)))
**** 1-shikiri **** *time*=1
*hito-mukashi*=(((●P (0))) ((●Q 2)))
**** 1-shikiri **** *time*=2
*hito-mukashi*=(((●P (0 0))) ((●Q 4)))
**** 1-shikiri **** *time*=3
*hito-mukashi*=(((●P (0 0 0))) ((●Q 6)))
**** 1-shikiri **** *time*=4
*hito-mukashi*=(((●P (0 0 0 0))) ((●Q 8)))
**** 1-shikiri **** *time*=5
*hito-mukashi*=(((●P (0 0 0 0 0))) ((●Q 10)))
**** 1-shikiri **** *time*=6
*hito-mukashi*=(((●P (0 0 0 0 0 0))) ((●Q 12)))
**** 1-shikiri **** *time*=7
*hito-mukashi*=(((●P (0 0 0 0 0 0 0))) ((●Q 14)))
**** 1-shikiri **** *time*=8
*hito-mukashi*=(((●P (0 0 0 0 0 0 0 0))) ((●Q 16)))
**** 1-shikiri **** *time*=9
*hito-mukashi*=(((●P (0 0 0 0 0 0 0 0 0))) ((●Q 18)))
**** 1-shikiri **** *time*=10
*hito-mukashi*=(((●P (0 0 0 0 0 0 0 0 0 0))) ((●Q 20)))
NIL
* 
* 

;;;;;;;;;;;; not.lsp の例 ;;;;;;;;;;;;;;;
* (load "not.lsp")

T
* (tmpro)
*ima-mukashi*=NIL *at_0*=((NIL))
*yaraneba*=(((●P) ~ (●Q) (PRINT " p ")) ((●Q) (PRINT " q ") ~ (●Q)))
**** 1-shikiri **** *time*=0
*hito-mukashi*=NIL
" p "
" q "
*yaraneba*=(((●P) ~ (●Q) (PRINT " p ")) ((●Q) (PRINT " q ") ~ (●Q)))
**** 1-shikiri **** *time*=1
*hito-mukashi*=(((●Q)) ((●P)))
" q "
**** 1-shikiri **** *time*=2
*hito-mukashi*=NIL
" p "
" q "
**** 1-shikiri **** *time*=3
*hito-mukashi*=(((●Q)) ((●P)))
" q "
**** 1-shikiri **** *time*=4
*hito-mukashi*=NIL
" p "
" q "
**** 1-shikiri **** *time*=5
*hito-mukashi*=(((●Q)) ((●P)))
" q "
**** 1-shikiri **** *time*=6
*hito-mukashi*=NIL
" p "
" q "
**** 1-shikiri **** *time*=7
*hito-mukashi*=(((●Q)) ((●P)))
" q "
**** 1-shikiri **** *time*=8
*hito-mukashi*=NIL
" p "
" q "
NIL
* 
* 
;;;;;; Prolog 実行例 ;;;;;;
* (load "tmpro114.lsp")   ;;; 本処理系のロード。
     ;2度目以降のロードで、defconstについて怒られたら、処理系ごとに対応。
     ; SBCL では、0: [CONTINUE] を選択。
*
;; Prolog Top levelの起動
* (proa)

@?-

  ; hanoi は、あらかじめ定義されている(新しい定義を行うと消去される)
@?-((hanoi 3 a b via))
A->B
A->VIA
B->VIA
A->B
VIA->A
VIA->B
A->B

result=T
reduced-goal=((HANOI 3 A B VIA))

@?-

  ; append は、あらかじめ定義されている(新しい定義を行うと消去される)
@?-((append *x *y (a s d)) (prin1 *x)(print *y) (fail))
NIL(A S D)
(A)(S D)
(A S)(D)
(A S D)NIL

result=NIL
reduced-goal=((APPEND *X *Y (A S D)) (PRIN1 *X) (PRINT *Y) (FAIL))

@?-

;; Prologの終了は「end」を入力する
@?-end

T
*
```

## 10. その他
この処理系(実行系)は、Prologとしては非常に素朴で、全然、性能は良くありません。(と言うより、むしろ悪い)  
この実行系は、テール・リカーシブ・インタープリタになっていません。  
このTemporal Prologは、同一時刻の中で無限(非常に長く実行する)ループを書いてはいけません。(ループ実行の間、時刻が進まなくなります)  
そもそも無限ループを書けないので、テール・リカーシブ・インタープリタでなくとも、それなりに実用的です。  
ループは、時間方向に繰り返しを書いてください。  


以上  
