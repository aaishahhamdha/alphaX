
function SubmitButton({buttonTitle}){
    return(
         <div>
            <button 
            style={
                {
                    backgroundColor: "var(--green)",
                    padding: "15px",
                    color: "var(--background-color)",
                    fontWeight: "bold",
                    width: "100%",
                    borderRadius: "5px",
                    border: "none",
                    fontSize: "var(--font-size-normal)"
                }
             }
            type="submit">
                {buttonTitle}
            </button>
         </div>
    );
}

export default SubmitButton;