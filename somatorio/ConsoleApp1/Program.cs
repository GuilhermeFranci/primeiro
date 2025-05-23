// See https://aka.ms/new-console-template for more information


class Program
{
    public static int soma(int[] somar){
        int i;
        int result = 0;
        for (i=0;i<5;i++){
            result += somar[i];
        }
        return result;
    }
    public static void Main(string[] args)
    {
        int[] somatorio = new int[5];
        int i;
        int resposta;
        for(i = 0;i<5;i++){
            Console.WriteLine("digite o "+i+"° numero:");
            somatorio[i] = Convert.ToInt32(Console.ReadLine());
        }
        resposta = soma(somatorio);
        Console.WriteLine(resposta);

        // Ask user for input and read a string from the console
        
    }
}
