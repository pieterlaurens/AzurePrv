using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.Extensions
{
    /// <summary>
    /// Extensions for the Type class.
    /// </summary>
    public static class TypeExtensions
    {
        /// <summary>
        /// To test whether a type implements the specified interface.
        /// </summary>
        /// <param name="type">The type to test.</param>
        /// <param name="interfaceType">The type to check if it implements it.</param>
        /// <returns>True when it does, false when not.</returns>
        public static bool ImplementsInterface(this Type type, Type interfaceType)
        {
            while (type != null && type != typeof(object))
            {
                if (type.GetInterfaces().Any(@interface =>
                    @interface.IsGenericType
                    && @interface.GetGenericTypeDefinition() == interfaceType))
                {
                    return true;
                }

                type = type.BaseType;
            }

            return false;
        }
    }

}
