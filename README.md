# README

カヌーの大会で使うシステムをRuby on Railsで開発中です。

URL: https://canoe-gakuren-app.herokuapp.com

## 開発の動機

自らが所属していたカヌー連盟のアナログな運営をデジタル化したいという思いはずっと抱いていたが、
開発経験の浅さなどからなかなか実行に移せずにいた。
そんな中、学部3年後期に行った計算機科学実験及演習4の授業で、データベースを使ったアプリケーションを作成した。
当時のリポジトリがhttps://github.com/MakotoNaruse/le4db-canoe_system であり、当時のレポートもここに入っている。

このアプリはJavaServletで書かされており実用化するのが難しかった(VPNなどのサーバーに載せるのが高かった)ため、Ruby on Railsで作り替えて実用化を目指すこことなる。

## 目指しているもの
大会の運営管理が一括で行えて、これから先、部活の後輩が何年も使い続けて結果を保存していけるようなシステム

## 開発履歴
|時期|やったこと|
|---:|:---|
|2018年11月|大学の授業にてjavaでのアプリケーション制作開始|
|2018年1月|制作終了|
|2018年2月|Ruby on Railsの勉強を一通り行う。|
|2019年3月|本アプリケーションの実装開始|
|2019年4月|授業で作ったもの以上のアプリケーション完成。<br>実用化に向け必要な機能を加えていく|
|2019年6月|webエントリー開始。実際に使われ始める|
|2019年8月|実際に大会で使用される。3つの大会期間中に15万回のアクセス|
|2020年5月|SQL改善など軽い改修を行う|
|2020年9月|結果入力のUX改善やアナリティクスの導入、軽微なUI改修など|
|2020年9月|二回目の大会。5日間で53,778PV、2,873AU|
|これから|他で勉強したことを生かし改修を進める|

## Todo
- MVCに沿った形でのコード周りでのリファクタリング<br>
  モデルの処理はしっかりとモデルに記述するように、読みやすいコードを
- 結果ページのUX改善
- フロント周りの改修<br>
  何かしらのフレームワーク入れてモダンなデザインにしたい、、。
