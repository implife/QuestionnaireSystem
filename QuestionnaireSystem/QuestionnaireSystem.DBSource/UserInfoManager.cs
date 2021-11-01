using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuestionnaireSystem.DBSource
{
    public class UserInfoManager
    {
        /// <summary>
        /// 根據特定使用者帳戶取得該使用者資料
        /// </summary>
        /// <param name="account"></param>
        /// <param name="pwd"></param>
        /// <returns></returns>
        public static UserInfo GetUserInfoByAccountPWD(string account, string pwd)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.UserInfoes.Where(user => user.Account == account && user.PWD == pwd).FirstOrDefault();
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }

        /// <summary>
        /// 根據UserID取得該使用者資料
        /// </summary>
        /// <param name="guid"></param>
        /// <returns></returns>
        public static UserInfo GetUserInfoByUserID(Guid guid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.UserInfoes.Where(user => user.UserID == guid).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
