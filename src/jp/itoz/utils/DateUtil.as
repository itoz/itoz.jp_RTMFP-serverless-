/**
 *============================================================
 * copyright(c) 2011-2012 www.itoz.jp
 * @author  itoz
 * 2011/12/1
 *============================================================
 */
package jp.itoz.utils
{
    import flash.errors.IllegalOperationError;

    /**
     * @author itoz2
     */
    public class DateUtil
    {
        function DateUtil()
        {
            throw new IllegalOperationError("DateUtil クラスはインスタンスを生成できません。");
        }

        public static function getTimeStamp() : String
        {
            var d : Date = new Date();
            return NumUtil.addZero(d.getHours(), 2) + ":" + NumUtil.addZero(d.getMinutes(), 2) + ":" + NumUtil.addZero(d.getSeconds(), 2);
        }
    }
}
