package ludi.forms;

class FormStyling {

    public static function addRenderer(renderer:FormItemRenderer):Void {
        @:privateAccess Form.renderers.push(renderer);
    }
    
    public static function getDefaultCSS(): String {
        return '
            .ludi-form-form-container {
                max-width: 600px;
                margin: 0 auto;
                padding: 20px;
                background: #ffffff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            .ludi-form-select {
                appearance: none;
                background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24"><path fill="%23333" d="M7 10l5 5 5-5z"/></svg>') no-repeat right 10px center !important;
                padding-right: 30px !important;
                cursor: pointer;
            }


            .ludi-form {
                font-family: 'Segoe UI', Arial, sans-serif;
            }


            .ludi-form-control-container {
                display: grid;
                grid-template-columns: minmax(0, 1fr) 2fr; 
                align-items: center;
                margin-bottom: 15px;
                gap: 15px;
            }


            .ludi-form-control-container > *:first-child {
                color: #333;
                font-size: 14px;
                font-weight: 500;
                text-align: right;
                padding-right: 10px;
                transition: color 0.2s ease;
            }


            .ludi-form-text,
            .ludi-form-number,
            .ludi-form-select {
                padding: 8px 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                background: #fff;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
                width: 100%; 
                box-sizing: border-box;
            }

            .ludi-form-text:focus,
            .ludi-form-number:focus,
            .ludi-form-select:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.2);
            }


            .ludi-form-text {
                
            }


            .ludi-form-number {
                
            }

            .ludi-form-number::-webkit-inner-spin-button,
            .ludi-form-number::-webkit-outer-spin-button {
                opacity: 1;
            }


            .ludi-form-checkbox {
                width: 18px;
                height: 18px;
                margin: 0;
                cursor: pointer;
                accent-color: #007bff;
                transition: transform 0.2s ease;
            }

            .ludi-form-checkbox:hover {
                transform: scale(1.1);
            }



            .ludi-form-option {
                padding: 8px;
            }


            .ludi-form-button {
                padding: 8px 20px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: background 0.2s ease, transform 0.1s ease;
                display: inline-block;
            }

            .ludi-form-button:hover {
                background: #0056b3;
            }

            .ludi-form-button:active {
                transform: scale(0.98);
            }


            .ludi-form-form-container .ludi-form-form-container {
                margin: 10px 0 0 20px;
                padding: 15px;
                background: #f8f9fa;
                border-left: 2px solid #007bff;
            }


            @media (max-width: 480px) {
                .ludi-form-form-container {
                    padding: 15px;
                }
                
                .ludi-form-control-container {
                    display: flex; 
                    flex-direction: column;
                    align-items: flex-start;
                    margin-bottom: 20px;
                    gap: 8px;
                }
                
                .ludi-form-control-container > *:first-child {
                    text-align: left; 
                    padding-right: 0;
                }
                
                .ludi-form-text,
                .ludi-form-number,
                .ludi-form-select {
                    font-size: 13px;
                    width: 100%;
                }
                
                .ludi-form-button {
                    width: 100%;
                }
            }
        ';
    }
}