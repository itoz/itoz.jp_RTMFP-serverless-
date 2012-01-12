/**
 * -------------------------------------------------------
 * copyright(c). www.itoz.jp
 * @author itoz
 * @version 2.2
 * -------------------------------------------------------
 * -update 2010.8.11	型指定追加　関数をstaticに変更
 * -update 2010.8.16 	パッケージ変更
 * -update 2010.12.27 	クラス名変更
 * -update 2011.1.5 	spliterメソッド追加
 * -update 2011.1.7 	combineメソッド追加
 * -update 2011.5.21    パッケージ変更	
 * -update 2011.5.31    concatToString削除 ( joinのほうが速かった。。。)
 * -updata 2011.6.2		createIntArray作成
 * -updata 2011.10.14	arrayCutter作成
 */
package jp.itoz.utils
{
    import flash.errors.IllegalOperationError;

    public class ArrayUtil
    {
        function ArrayUtil()
        {
            throw new IllegalOperationError("ArrayUtil クラスはインスタンスを生成できません。");
        }

        // ======================================================================
        /**
         * 指定配列を、ランダムに並べ替え
         * 元の配列は変更しない
         * 　@param : arr ターゲット配列
         *
         * @example :
         * <listing version="3.0">
         *  var aList =["a","b","c","d","e"]  
         *  trace(ArrayUtil.rndSort(aList))
         *  // 出力　c,a,e,b,d
         *  </listing>
         */
        public static function rndSort(arr : Array) : Array
        {
            var result : Array = arr.slice();
            var rndNumArr : Array = rndNum(arr.length);
            result = arraySort(result, rndNumArr);
            return result;
        }

        // ======================================================================
        /**
         * 指定配列を、指定された配列順に並べ替え
         * 
         * @param arr 並べ替えたい配列
         * @param sortArr 並べ替えたい順番の配列
         * 
         * @example :
         * <listing version="3.0">
         *  var aList   = ["a","b","c","d","e"]
         *  var numList = [ 2 , 1 , 0 , 3 , 4 ]
         *  trace(ArrayUtil.arraySort(aList,numList))
         *  // 出力　c,b,a,d,e
         *  </listing>
         */
        public static function arraySort(arr : Array, sortArr : Array) : Array
        {
            var result : Array = [];
            var max : int = sortArr.length;
            if (arr.length != max) {
                throw new IllegalOperationError("ArrayUtil " + " 指定された配列同士のlengthが一致しません。");
            }
            else {
                for (var i : int = 0; i < max; i++) {
                    var trgInt : int = sortArr[i];
                    result.push(arr[trgInt]);
                }
            }
            return result;
        }

        // ======================================================================
        /**
         * 配列の長さを指定の長さにカット
         * 元は変更しない
         * 指定の長さのほうがながければ、複製を返す
         */
        public static function arrayCutter(array : Array, leng : int) : Array
        {
            if (array.length <= leng) return array.concat();
            var result : Array = [];
            for (var i : int = 0; i < leng; i++) {
                result.push(array[i]);
            }
            return result;
        }

        // ======================================================================
        /**
         * 指定の長さにintが入った配列作成
         * @param n length
         * @example :
         * <listing version="3.0">
         *  trace(ArrayUtil.createIntArray(5))
         *  // 出力　0,1,2,3,4,5
         *  </listing>
         */
        public static function createIntArray(n : int) : Array
        {
            var result : Array = [];
            for (var i : int = 0; i < n; i++) {
                result.push(i);
            }
            return result;
        }

        // ======================================================================
        /**
         * ランダム数値配列を作成
         * 　@param  nn 返してほしい配列のlengthを指定
         *
         * @example :
         * <listing version="3.0">
         *  trace(ArrayUtil.rndNum(18))
         *  // 出力　0,4,3,9,14,2,8,1,12,16,11,5,7,17,13,6,15,10
         *  </listing>
         */
        public static function rndNum(nn : int) : Array
        {
            var result : Array = [];
            var _pushCnt : int = 0;
            while (_pushCnt != nn) {
                var rr : int = int(Math.random() * nn);
                var arrCheck : int = result.indexOf(rr);
                if (arrCheck == -1) {
                    result[_pushCnt] = rr;
                    _pushCnt++;
                }
            }
            return result;
        }

        // ======================================================================
        /**
         * 指定位置を取り除いた配列を返す
         * 元の配列は変更しない
         * 
         * @param  index 取り除きたい位置
         * @param  trgArr ターゲット配列
         *
         * @example :
         * <listing version="3.0">
         *  var aList = [0,1,2,3,4,5,6]
         *  trace( ArrayUtil.cutOut(2,aList))
         *  // 出力　0,1,3,4,5,6
         *  </listing>
         */
        public static function cutOut(index : int, trgArr : Array) : Array
        {
            var result : Array = trgArr.slice();
            var spltArr : Array = result.splice(index);
            spltArr.shift();
            result = result.concat(spltArr);
            return result;
        }

        // ======================================================================
        /**
         * 指定文字列の登場順にならべかえる
         * 
         * @param  arr ターゲット配列
         * @param  indexStr 検索文字
         *
         * @example :"あ"が出てくる順に並べ替え
         * <listing version="3.0">
         *  var aList =  ["いあうえお","えういあお","ういああお","あいうえお","いえうあう","いああえお","うえいあ"]
         *  trace( ArrayUtil.sortStringIndex(aList,"あ"))
         *  // 出力　	あいうえお,いああえお,いあうえお,ういああお,いえうあう,うえいあ,えういあお
         *  </listing>
         */
        public static function sortStringIndex(arr : Array, indexStr : String) : Array
        {
            var result : Array = [];
            var sortArr : Array = [];
            var undefindArr : Array = [];
            for (var j : int = 0; j < arr.length; j++) {
                var p : String = arr[j];
                var index : int = p.indexOf(indexStr, 0);
                if ( index != -1) {
                    if (null == sortArr[index]) {
                        sortArr[index] = [];
                    }
                    sortArr[index].push(p);
                }
                else {
                    undefindArr.push(p);
                }
            }
            sortArr.push(undefindArr);
            // TODO 2次元を1次元にしているので、このクラスのメソッドで代用できるように?する
            for (var k : int = 0; k < sortArr.length; k++) {
                if (sortArr[k] != null) {
                    sortArr[k].sort();
                    for (var h : int = 0; h < sortArr[k].length; h++) {
                        result.push(sortArr[k][h]);
                    }
                }
            }
            return result;
        }

        // ======================================================================
        /**
         * オブジェクト配列の値を元に、指定文字列の登場順にならべかえる
         * sortStringIndexのObject版
         * 
         * @param  arr ターゲット配列
         * @param  key オブジェクトのキー
         * @param  indexStr 検索文字
         *
         * @example :name に"あ"が出てくる順にオブジェクト配列並べ替え
         * <listing version="3.0">
         *  var aList =  [{"name":"いあうえお"},{"name":"えういあお"},{"name":"ういああお"},{"name":"あいうえお"},{"name":"いえうあう"},{"name":"いああえお"},{"name":"うえいあ"}]
         * var result:Array = ArrayUtil.sortOnStringIndex(aList,"name","あ")
         *  for (var i : int = 0; i < result.length; i++) {
         *  	for (var j : String in result[i]) {trace(d[i][j])}
         *  }
         *  // あいうえお
         *  // いああえお
         *  // いあうえお
         *  // ういああお
         *  // いえうあう
         *  // うえいあ
         *  // えういあお
         *  </listing>
         */
        public static function sortOnStringIndex(arr : Array, key : String, indexStr : String) : Array
        {
            var result : Array = [];
            var sortArr : Array = [];
            var undefindArr : Array = [];
            for (var j : int = 0; j < arr.length; j++) {
                var p : Object = arr[j];
                var index : int = p[key].indexOf(indexStr);
                if ( index != -1) {
                    if (null == sortArr[index]) {
                        sortArr[index] = [];
                    }
                    sortArr[index].push(p);
                }
                else {
                    undefindArr.push(p);
                }
            }
            sortArr.push(undefindArr);
            for (var k : int = 0; k < sortArr.length; k++) {
                if (sortArr[k] != null) {
                    sortArr[k].sortOn(key);
                    for (var h : int = 0; h < sortArr[k].length; h++) {
                        result.push(sortArr[k][h]);
                    }
                }
            }
            return result;
        }

        // ======================================================================
        /**
         * 指定配列を、分割した配列を返す
         * @param trgArr
         * @param maxNum 何個ずつに分割するか
         * 
         * @example :アルファベットを７こづつに分割した配列を作成
         * <listing version="3.0">
         * var t:Array = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
         * var r:Array = ArrayUtil.spliter(t,7)
         * for (var i : int = 0; i < r.length; i++) {
         * 	trace(r[i]);
         * }
         * // a,b,c,d,e,f,g
         * // h,i,j,k,l,m,n
         * // o,p,q,r,s,t,u
         * // v,w,x,y,z
         *  </listing>
         */
        public static function spliter(trgArr : Array, maxNum : int) : Array
        {
            var result : Array = [];
            for (var i : int = 0; i < trgArr.length; i++) {
                var splitArr : Array = result[int(i / maxNum)];
                if (splitArr == null) {
                    splitArr = [];
                    result.push(splitArr);
                }
                splitArr.push(trgArr[i]);
            }
            return result;
        }

        // ======================================================================
        /**
         * 2次元配列を1次元に
         */
        public static function combine(arr : Array) : Array
        {
            var result : Array = [];
            for (var i : int = 0; i < arr.length; i++) {
                var innerArr : Array = arr[i];
                for (var j : int = 0; j < innerArr.length; j++) {
                    result.push(innerArr[j]);
                }
            }
            return result;
        }

        // ======================================================================
        /**
         * 配列同士の中身が同じ値か比較する
         */
        public static function equal(array0 : Array, array1 : Array) : Boolean
        {
            if ( array0 == null || array1 == null) return false;
            if (array0.length != array1.length) return false;
            for (var i : int = 0; i < array0.length; i++) {
                if (array0[i] != array1[i]) return false;
            }
            return true;
        }

        /**
         * arr0の値がarr1の何番目に格納されているか取得
         * @param arr0 対象の配列
         * @param arr1 検索される配列
         * @example :アルファベットを７こづつに分割した配列を作成
         * <listing version="3.0">
         *  trace(ArrayUtil.getFindIndexies([1,3,5,7],[2,5,6,13,7]))
         * // -1,-1,1,4
         *  </listing>
         */
        public static function getFindIndexies(arr0 : Array, arr1 : Array) : Array
        {
            var result : Array = [];
            for (var i : int = 0; i < arr0.length; i++) {
                var findIndex : int = arr1.indexOf(arr0[i]);
                result.push(findIndex);
            }
            return result;
        }

        /**
         * 配列AとBを比較して
         * AにはあるがBにないものをピックアップした配列を返す
         */
        public static function getUndefind(array0 : Array, array1 : Array) : Array
        {
            var result : Array = [];
            for (var i : int = 0; i < array0.length; i++) {
                var index : int = array1.indexOf(array0[i]);
                if (index == -1) {
                    result.push(array0[i]);
                }
            }
            return result;
        }

        /**
         * 指定配列の指定位置に指定要素を挿入
         */
        public static function insert(array : Array, insertIndex : int, data : *) : Array
        {
            var result : Array = array.slice();
            var spltArr : Array = result.splice(insertIndex);
            spltArr.push(data);
            result = result.concat(spltArr);
            return result;
        }
    }
}