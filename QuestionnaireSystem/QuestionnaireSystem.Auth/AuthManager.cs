using QuestionnaireSystem.DBSource;
using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuestionnaireSystem.Auth
{
    public class AuthManager
    {
        public static Guid? AuthGuid(string strGuid, out string errMsg)
        {
            if (strGuid == null)
            {
                errMsg = "StringNull";
                return null;
            }

            Guid? guid = null;
            try
            {
                guid = Guid.Parse(strGuid);
            }
            catch (Exception ex)
            {
                errMsg = "ParseError";
                return null;
            }

            errMsg = "";
            return guid;
        }

        public static Voter AuthVoterGuid(string strVoterGuid, out string errMsg)
        {
            Guid? voterID = AuthGuid(strVoterGuid, out errMsg);
            if (voterID == null)
            {
                return null;
            }

            Voter voter = QuestionManager.GetVoterByVoterID((Guid)voterID);

            if (voter == null)
            {
                errMsg = "NoData";
                return null;
            }

            errMsg = "";
            return voter;
        }

        public static Questionnaire AuthQuestionnaireGuid(string strQuestionnaireGuid, out string errMsg)
        {
            Guid? questionnaireID = AuthGuid(strQuestionnaireGuid, out errMsg);
            if (questionnaireID == null)
            {
                return null;
            }

            Questionnaire questionnaire = QuestionManager.GetQuestionnaireByID((Guid)questionnaireID);

            if (questionnaire == null)
            {
                errMsg = "No Questionnaire found.";
                return null;
            }

            errMsg = "";
            return questionnaire;
        }
    }
}
